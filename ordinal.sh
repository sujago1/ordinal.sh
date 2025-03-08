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
    "oats make me bloated"
    "where is 562 area code"
    "how to make a paper airplane"
    "how to not snore"
    "f how to write"
    "where is 717 area code"
    "5 things that make me happy"
    "where liver located"
    "zyn pouches how to"
    "only you can make me happy"
    "why kiki"
    "how to 6 sc in a magic ring"
    "make me tell you i'm in love with you lyrics"
    "krispy kreme where is it from"
    "why just why"
    "63183 make me a winner"
    "xlimkid make me cry lyrics"
    "q tips make me cough"
    "google docs how to"
    "21 give me something"
    "zodiac killer why"
    "how to 45 j channel"
    "the summer i turned pretty where is it"
    "olive garden where"
    "02.04 give me liberty"
    "why does delta 8 give me a headache"
    "and give me one more chance"
    "make me definition"
    "uncanny valley why"
    "make me 3d"
    "where is constantinople"
    "where is 404 area code"
    "where have all the flowers gone lyrics"
    "how to pick a good watermelon"
    "where zach bryan from"
    "stanley cup why"
    "louis vuitton where is it from"
    "where is lebanon"
    "what is give me hope joanna about"
    "where is 0 degrees longitude"
    "york university where is it"
    "o give me a home where the buffalo roam lyrics"
    "90s hairstyles how to"
    "only you can make me feel this way lyrics"
    "why files podcast"
    "make me laugh"
    "where is resident alien filmed"
    "essence make me brow 02 browny brows"
    "why eat chia seeds"
    "give me glow cosmetics"
    "how to 90 degree hold"
    "eggs make me nauseous"
    "where zebras live"
    "how to edit a pdf"
    "where 505 area code is located"
    "where 855 area code"
    "roller coasters make me sad"
    "where is estonia"
    "give me liberty pdf"
    "where 760 area code"
    "3d printer how to"
    "75 hard challenge how to"
    "please give me coke"
    "bianca censori why"
    "how to 6-3 stack tetris"
    "how to open task manager"
    "eclipse 2024 where is it"
    "love you give me cast"
    "why questions list"
    "from where is h&m"
    "where eagles dare lyrics"
    "how to eat crawfish"
    "please give me"
    "vous worship give me jesus"
    "quotes give me a chance"
    "meme give me money"
    "where is prague"
    "2 glasses of wine make me drunk"
    "utorrent how to download"
    "i wear dolls barcelona"
    "why not both meme"
    "where is routing number on check"
    "zack tabudlo give me your forever lyrics"
    "where is scp 049 from"
    "where is 206 area code"
    "6ix give me the cash"
    "puerto vallarta where is it"
    "how to increase metabolism"
    "why am i peeing so much"
    "where you go i go lyrics"
    "make me up ga"
    "how to quit smoking"
    "give me the weather for today"
    "from where is ariana grande"
    "for why urban dictionary"
    "xbox controller where is"
    "morgan wallen where from"
    "98 degrees give me just one night lyrics"
    "give me 3 margaritas song"
    "how to unpair apple watch"
    "kevin mccarthy why"
    "where is xur"
    "how to zoom out on chromebook"
    "why do i sweat so much"
    "where 771 area code"
    "where was dune filmed"
    "where is shur located"
    "where is 323 area code"
    "why zelle pending"
    "hdfc netbanking how to login"
    "why so many shark attacks"
    "how to vote for american idol"
    "where 6666 ranch"
    "how to block someone on tiktok"
    "xcaret hotel where is it"
    "why vietnam war"
    "ost the love you give me"
    "give me 4 margaritas"
    "real estate why real"
    "zac efron jaw why"
    "chapter 24 give me liberty"
    "why xbox is better than ps5"
    "5 pillars of islam where"
    "why thank you"
    "give me 9 characters to draw"
    "make me summer o'toole"
    "how to watch wimbledon 2024"
    "where versus were"
    "give me 3 words"
    "sex education where"
    "big brother i want you to give me"
    "how to open a combination lock"
    "give me jesus chords"
    "give me 6 ships to draw"
    "how to cook bacon in the oven"
    "where 9/11 take place"
    "where was jesus crucified"
    "zayn malik from where"
    "where did beryl make landfall"
    "taylor swift where is"
    "where is uc davis"
    "5 things that make me feel peaceful today"
    "o where is the atacama desert located"
    "quiet on set where"
    "where is 626 area code"
    "give me zangi"
    "yorkshire wildlife park where is it"
    "why was the berlin wall built"
    "don't give me hope meme"
    "volcano iceland where is it"
    "where is 518 area code"
    "make me smile chicago lyrics"
    "why green poop"
    "how to zest a lemon"
    "how to 50150 someone"
    "make me excited synonym"
    "how to enable imessage"
    "where questions with pictures"
    "0330 numbers where from"
    "where is fallout 4 set"
    "where is bora bora"
    "how to translate on google"
    "where did the titanic sink"
    "how to be a 00 agent"
    "let me make you an offer (78288)"
    "how to download kruti dev 010 font"
    "barbie movie where"
    "where is tom holland from"
    "where can i watch love island usa"
    "does sugar make me tired"
    "give me a break give me a break"
    "queen mary ship where is it"
    "where is ohio"
    "make me jump meaning"
    "flip a coin how to"
    "travis kelce is from where"
    "how to reset airpods"
    "how to watch euro 2024"
    "grimace shake why"
    "make me sweat"
    "where has hurricane beryl hit"
    "lady gaga where is from"
    "why homework should be banned"
    "super bowl 2024 where"
    "i wear in spanish"
    "4 how to calculate"
    "811 where to dig"
    "where to stream young sheldon"
    "how to write a letter"
    "eclipse 2024 why"
    "where banana meme"
    "where pepper.com"
    "where is 10 things i hate about you"
    "magic make me a winner"
    "essence make me brow 04 ashy brows"
    "how to zoom out on mac"
    "10 days how to lose a guy"
    "how to value a business"
    "hangover 3 where is it"
    "646 where is area code"
    "where is el salvador"
    "where queen latifah from"
    "02 arena where is it"
    "din tai fung where is it from"
    "steam deck how to"
    "marks and spencer where is it from"
    "where focus goes energy flows"
    "lyrics give me one reason"
    "how to eat chia seeds"
    "xavier university where is it"
    "keto diet how to"
    "where is 833 area code"
    "make me an instrument of your peace"
    "quinoa how to cook"
    "how to make slime"
    "quickbooks"
    "13 colonies where"
    "eurovision 2023 where"
    "uber eats how to"
    "929 area code where is it"
    "is where i'm from where i was born"
    "now make me a sandwich menu"
    "flowers make me happy"
    "dave's hot chicken where is it from"
    "dad jokes why"
    "post malone is from where"
    "game of thrones where"
    "give me u lyrics"
    "where is 832 area code"
    "how to get a passport"
    "ryan garcia is from where"
    "jupyter notebook how to"
    "janelle monae make me feel"
    "vitamin d3 why"
    "make me royal reviews"
    "x where the camera is on snapchat"
    "jesus make me smile again lyrics"
    "puerto rico where is it"
    "why can't dogs have grapes"
    "mega millions how to"
    "70s show where is"
    "why bbl drizzy"
    "why does sperm make me smell fishy"
    "eggs make me feel sick"
    "where is new zealand"
    "e why stream"
    "stanley cup where is it"
    "2023 women's world cup where"
    "where zach randolph from"
    "where 13 reasons why filmed"
    "how to make me laugh"
    "signal 1 make me a winner"
    "how to bake a potato"
    "why lyrics"
    "make me better lyrics"
    "where is 1923 streaming"
    "quotes you give me butterflies"
    "760 area code where is it"
    "where is oregon"
    "how to 3 point turn"
    "give me home depot"
    "doja cat why why"
    "give me google maps"
    "6 how to calculate"
    "make me nails"
    "how to be on 007 road to a million"
    "how to 0.5 on iphone xr"
    "why lease a car"
    "where is virgin river filmed"
    "l how to go live on tiktok"
    "i make medicine sick"
    "21 savage from where"
    "0333 numbers where from"
    "zion national park where is it"
    "solar eclipse how to"
    "civ 6 how to"
    "make me elegant"
    "make me bark"
    "where is outer banks"
    "rugby world cup where"
    "sci hub where is"
    "why bitcoin is down"
    "where is orange county"
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
