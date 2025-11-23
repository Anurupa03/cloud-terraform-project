package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-redis/redis/v8"
	_ "github.com/lib/pq"
)

type HealthResponse struct {
	Status  string `json:"status"`
	Service string `json:"service"`
}

type DataResponse struct {
	Message   string `json:"message"`
	DBVersion string `json:"db_version"`
	Cached    bool   `json:"cached"`
}

type CacheStatsResponse struct {
	TotalCommands   int64 `json:"total_commands"`
	KeyspaceHits    int64 `json:"keyspace_hits"`
	KeyspaceMisses  int64 `json:"keyspace_misses"`
}

type ErrorResponse struct {
	Error string `json:"error"`
}

var (
	db          *sql.DB
	redisClient *redis.Client
	ctx         = context.Background()
)

func initDB() error {
	dbHost := getEnv("DB_HOST", "postgres_db")
	dbName := getEnv("DB_NAME", "appdb")
	dbUser := getEnv("DB_USER", "admin")
	dbPassword := getEnv("DB_PASSWORD", "secret")

	connStr := fmt.Sprintf(
		"host=%s dbname=%s user=%s password=%s sslmode=disable",
		dbHost, dbName, dbUser, dbPassword,
	)

	var err error
	
	// Retry up to 10 times with 2-second delays
	for i := 0; i < 10; i++ {
		db, err = sql.Open("postgres", connStr)
		if err == nil {
			err = db.Ping()
			if err == nil {
				return nil // Success!
			}
		}
		log.Printf("Database not ready, retrying... (%d/10): %v", i+1, err)
		time.Sleep(2 * time.Second)
	}

	return fmt.Errorf("failed to connect to database after 10 retries: %v", err)
}

func initRedis() error {
	redisHost := getEnv("REDIS_HOST", "redis_cache")

	redisClient = redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:6379", redisHost),
		Password: "",
		DB:       0,
	})

	var err error
	
	// Retry up to 10 times with 2-second delays
	for i := 0; i < 10; i++ {
		err = redisClient.Ping(ctx).Err()
		if err == nil {
			return nil // Success!
		}
		log.Printf("Redis not ready, retrying... (%d/10): %v", i+1, err)
		time.Sleep(2 * time.Second)
	}

	return fmt.Errorf("failed to connect to Redis after 10 retries: %v", err)
}


func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(HealthResponse{
		Status:  "healthy",
		Service: "backend",
	})
}

func dataHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Try to get from cache first
	cachedData, err := redisClient.Get(ctx, "db_version").Result()
	if err == nil && cachedData != "" {
		// Cache hit
		json.NewEncoder(w).Encode(DataResponse{
			Message:   "Data from Redis cache",
			DBVersion: cachedData,
			Cached:    true,
		})
		return
	}

	// Cache miss - get from database
	var version string
	err = db.QueryRow("SELECT version()").Scan(&version)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(ErrorResponse{
			Error: err.Error(),
		})
		return
	}

	// Store in cache for 60 seconds
	redisClient.Set(ctx, "db_version", version, 60*time.Second)

	json.NewEncoder(w).Encode(DataResponse{
		Message:   "Data from database (cached for 60s)",
		DBVersion: version,
		Cached:    false,
	})
}

func cacheStatsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	_ , err := redisClient.Info(ctx, "stats").Result()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(ErrorResponse{
			Error: err.Error(),
		})
		return
	}

	stats := CacheStatsResponse{
		TotalCommands:  0,
		KeyspaceHits:   0,
		KeyspaceMisses: 0,
	}

	json.NewEncoder(w).Encode(stats)
}

func main() {
	log.Println("Connecting to database...")
	if err := initDB(); err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer db.Close()
	log.Println("Database connected!")

	log.Println("Connecting to Redis...")
	if err := initRedis(); err != nil {
		log.Fatal("Failed to connect to Redis:", err)
	}
	defer redisClient.Close()
	log.Println("Redis connected!")

	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/api/data", dataHandler)
	http.HandleFunc("/api/cache-stats", cacheStatsHandler)

	port := ":5000"
	log.Printf("Server starting on port %s", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		log.Fatal("Server failed:", err)
	}
}