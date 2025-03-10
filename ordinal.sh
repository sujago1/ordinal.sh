# Check if jq is installed, and if not, install it
if ! command -v jq &> /dev/null; then
    echo "❌ jq not found. Installing jq..."
    sudo apt update && sudo apt install jq -y
    if [ $? -eq 0 ]; then
        echo "✅ jq installed successfully!"
    else
        echo "❌ Failed to install jq. Please install jq manually and re-run the script."
        exit 1
    fi
else
    echo "✅ jq is already installed."
fi

# List of general questions
general_questions=(
        "What is 1 x 1 = "
    "What is 1 x 2 = "
    "What is 1 x 3 = "
    "What is 1 x 4 = "
    "What is 1 x 5 = "
    "What is 1 x 6 = "
    "What is 1 x 7 = "
    "What is 1 x 8 = "
    "What is 1 x 9 = "
    "What is 1 x 10 = "
    "What is 2 x 1 = "
    "What is 2 x 2 = "
    "What is 2 x 3 = "
    "What is 2 x 4 = "
    "What is 2 x 5 = "
    "What is 2 x 6 = "
    "What is 2 x 7 = "
    "What is 2 x 8 = "
    "What is 2 x 9 = "
    "What is 2 x 10 = "
    "What is 3 x 1 = "
    "What is 3 x 2 = "
    "What is 3 x 3 = "
    "What is 3 x 4 = "
    "What is 3 x 5 = "
    "What is 3 x 6 = "
    "What is 3 x 7 = "
    "What is 3 x 8 = "
    "What is 3 x 9 = "
    "What is 3 x 10 = "
    "What is 4 x 1 = "
    "What is 4 x 2 = "
    "What is 4 x 3 = "
    "What is 4 x 4 = "
    "What is 4 x 5 = "
    "What is 4 x 6 = "
    "What is 4 x 7 = "
    "What is 4 x 8 = "
    "What is 4 x 9 = "
    "What is 4 x 10 = "
    "What is 5 x 1 = "
    "What is 5 x 2 = "
    "What is 5 x 3 = "
    "What is 5 x 4 = "
    "What is 5 x 5 = "
    "What is 5 x 6 = "
    "What is 5 x 7 = "
    "What is 5 x 8 = "
    "What is 5 x 9 = "
    "What is 5 x 10 = "
    "What is 6 x 1 = "
    "What is 6 x 2 = "
    "What is 6 x 3 = "
    "What is 6 x 4 = "
    "What is 6 x 5 = "
    "What is 6 x 6 = "
    "What is 6 x 7 = "
    "What is 6 x 8 = "
    "What is 6 x 9 = "
    "What is 6 x 10 = "
    "What is 7 x 1 = "
    "What is 7 x 2 = "
    "What is 7 x 3 = "
    "What is 7 x 4 = "
    "What is 7 x 5 = "
    "What is 7 x 6 = "
    "What is 7 x 7 = "
    "What is 7 x 8 = "
    "What is 7 x 9 = "
    "What is 7 x 10 = "
    "What is 8 x 1 = "
    "What is 8 x 2 = "
    "What is 8 x 3 = "
    "What is 8 x 4 = "
    "What is 8 x 5 = "
    "What is 8 x 6 = "
    "What is 8 x 7 = "
    "What is 8 x 8 = "
    "What is 8 x 9 = "
    "What is 8 x 10 = "
    "What is 9 x 1 = "
    "What is 9 x 2 = "
    "What is 9 x 3 = "
    "What is 9 x 4 = "
    "What is 9 x 5 = "
    "What is 9 x 6 = "
    "What is 9 x 7 = "
    "What is 9 x 8 = "
    "What is 9 x 9 = "
    "What is 9 x 10 = "
    "What is 10 x 1 = "
    "What is 10 x 2 = "
    "What is 10 x 3 = "
    "What is 10 x 4 = "
    "What is 10 x 5 = "
    "What is 10 x 6 = "
    "What is 10 x 7 = "
    "What is 10 x 8 = "
    "What is 10 x 9 = "
    "What is 10 x 10 = "
)

# Function to get a random general question
generate_random_general_question() {
    echo "${general_questions[$RANDOM % ${#general_questions[@]}]}"
}

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"

    echo "📬 Sending Question: $message"

    json_data=$(cat <<EOF
{
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "$message"}
    ]
}
EOF
    )

    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" \
        -H "Authorization: Bearer $api_key" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -d "$json_data")

    http_status=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | head -n -1)

    # Extract the 'content' from the JSON response using jq (Suppress errors)
    response_message=$(echo "$body" | jq -r '.choices[0].message.content' 2>/dev/null)

    if [[ "$http_status" -eq 200 ]]; then
        if [[ -z "$response_message" ]]; then
            echo "⚠️ Response content is empty!"
        else
            ((success_count++))  # Increment success count
            echo "✅ [SUCCESS] Response $success_count Received!"
            echo "📝 Question: $message"
            echo "💬 Response: $response_message"
        fi
    else
        echo "⚠️ [ERROR] API request failed | Status: $http_status | Retrying..."
        sleep 2
    fi
}

# Asking for API Key (loops until a valid key is provided)
while true; do
    echo -n "Enter your API Key: "
    read -r api_key

    if [ -z "$api_key" ]; then
        echo "❌ Error: API Key is required!"
        echo "🔄 Restarting the installer..."

        # Restart installer
        rm -rf ~/gaiainstaller.sh
        curl -O https://raw.githubusercontent.com/abhiag/Gaiatest/main/gaiainstaller.sh && chmod +x gaiainstaller.sh && ./gaiainstaller.sh 

        exit 1
    else
        break  # Exit loop if API key is provided
    fi
done

# Asking for duration
echo -n "⏳ How many hours do you want the bot to run? "
read -r bot_hours

# Convert hours to seconds
if [[ "$bot_hours" =~ ^[0-9]+$ ]]; then
    max_duration=$((bot_hours * 3600))
    echo "🕒 The bot will run for $bot_hours hour(s) ($max_duration seconds)."
else
    echo "⚠️ Invalid input! Please enter a number."
    exit 1
fi

# Hidden API URL (moved to the bottom)
API_URL="https://ordinal.gaia.domains/v1/chat/completions"

# Display thread information
echo "✅ Using 1 thread..."
echo "⏳ Waiting 30 seconds before sending the first request..."
sleep 5

echo "🚀 Starting requests..."
start_time=$(date +%s)
success_count=0  # Initialize success counter

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [[ "$elapsed" -ge "$max_duration" ]]; then
        echo "🛑 Time limit reached ($bot_hours hours). Exiting..."
        echo "📊 Total successful responses: $success_count"
        exit 0
    fi

    random_message=$(generate_random_general_question)
    send_request "$random_message" "$api_key"
    sleep 0
done
