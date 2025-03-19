# Soal 2 

## a. “First Step in a New World”

Membuat folder data dan file player.csv
```bash
$ mkdir data && touch player.csv
```
Membuat register.sh
```bash
$ nano register.sh
```
Membuat Kode register.sh
```bash
#!/bin/bash

DATABASE="data/player.csv"
STATIC_SALT="ArcaeaSecretPassword"

valid_email() {
    local email="$1"
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

valid_password() {
    local password="$1"
    [[ ${#password} -ge 8 && "$password" =~ [a-z] && "$password" =~ [A-Z] && "$password" =~ [0-9] ]]
}

email="$1"
username="$2"
password="$3"

if ! valid_email "$email"; then
    echo "Error: Invalid email format."
    exit 1
fi

if ! valid_password "$password"; then
    echo "Error: Password must be at least 8 characters, include uppercase, lowercase, and a number."
    exit 1
fi

if grep -q "^$email," "$DATABASE"; then
    echo "Error: Email already registered!"
    exit 1
fi

hashed_password=$(echo -n "${STATIC_SALT}${password}" | sha256sum | awk '{print $1}')

echo "$email,$username,$hashed_password" >> "$DATABASE"
```

Membuat login.sh
```bash
$ nano login.sh
```
Membuat Kode Login.sh
```bash
#!/bin/bash

DATABASE="data/player.csv"
STATIC_SALT="ArcaeaSecretPassword"

email="$1"
password="$2"

if ! grep -q "^$email," "$DATABASE"; then
    echo "Error: Email not registered!"
    exit 1
fi

hashed_password=$(echo -n "${STATIC_SALT}${password}" | sha256sum | awk '{print $1}')

data_hash=$(awk -F ',' -v email="$email" '$1 == email {print $3}' "$DATABASE")

if [ "$hashed_password" == "$data_hash" ]; then
    echo "Login successful!"

    ./scripts/core_monitor.sh

else
    echo "Error: Incorrect password!"
    exit 1
fi
```
## b. “Radiant Genesis”

Email harus memiliki format yang benar dengan tanda @ dan titik
```bash
valid_email() {
    local email="$1"
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}
```
Dapat di cek dengan
```bash
if ! valid_email "$email"; then
    echo "Error: Invalid email format."
    exit 1
fi
```
Password harus memiliki minimal 8 karakter, setidaknya satu huruf kecil, satu huruf besar, dan satu angka 
```bash
valid_password() {
    local password="$1"
    [[ ${#password} -ge 8 && "$password" =~ [a-z] && "$password" =~ [A-Z] && "$password" =~ [0-9] ]]
}
```
Dapat di cek dengan
```bash
if ! valid_password "$password"; then
    echo "Error: Password must be at least 8 characters, include uppercase, lowercase, and a number."
    exit 1
fi
```

## c. “Unceasing Spirit”

Jadikan sistem login/register tidak bisa memakai email yang sama (email = unique)

Pada register.sh dapat menggunakan
```bash
if grep -q "^$email," "$DATABASE"; then
    echo "Error: Email already registered!"
    exit 1
fi
```
Pada login.sh dapat menggunakan
```bash
if ! grep -q "^$email," "$DATABASE"; then
    echo "Error: Email not registered!"
    exit 1
fi
```

## d. “The Eternal Realm of Light”

Menggunakan algoritma hashing sha256sum yang memakai static salt untuk menjaga keamanan password. 

Pada register.sh dan login.sh dapat menambahkan kode ini
```bash
STATIC_SALT="ArcaeaSecretPassword"
```
```bash
hashed_password=$(echo -n "${STATIC_SALT}${password}" | sha256sum | awk '{print $1}')
```
Tambahan untuk login.sh 
```bash
data_hash=$(awk -F ',' -v email="$email" '$1 == email {print $3}' "$DATABASE")

if [ "$hashed_password" == "$data_hash" ]; then
    echo "Login successful!"
else
    echo "Error: Incorrect password!"
    exit 1
fi
```

## e. “The Brutality of Glass”

Membuat Persentase CPU dan model dari CPU yang kita gunakan dan lokasinya berada di ./scripts/core_monitor.sh

Membuat folder scripts dan masuk
```bash
$ mkdir scripts && cd scripts
```
Persentase CPU dan Model CPU menggunakan shell scripts
```bash
$ nano core_monitor.sh
```
```bash
#!/bin/bash

LOG_DIR="logs"
CORE_LOG="$LOG_DIR/core.log"

mkdir -p "$LOG_DIR"

times=$(date +"%Y-%m-%d %H:%M:%S")

echo "------------------------------------------"
echo "               Arcaea Core                "
echo "------------------------------------------"

cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
cpu_model=$(grep "model name" /proc/cpuinfo | awk -F ':' 'NR==1 {print $2}'| awk '{$1=$1; print}')

echo "Terminal: $cpu_model"
echo "Core Usage: $cpu_usage%"
echo "======================================"

echo "[$times] - Core Usage [$cpu_usage%] - Terminal Model [$cpu_model]" >> "$CORE_LOG"

./scripts/frag_monitor.sh
```

## f. “In Grief and Great Delight”

Persentase RAM dan Penggunaan RAM menggunakan shell scripts serta berada di lokasi ./scripts/frag_monitor.sh
```bash
$ nano frag_Monitor.sh
```
```bash
#!/bin/bash

LOG_DIR="logs"
FRAG_LOG="$LOG_DIR/fragment.log"

mkdir -p "$LOG_DIR"

times=$(date +"%Y-%m-%d %H:%M:%S")

echo "-----------------------------------------"
echo "            Arcaea Fragment              "
echo "-----------------------------------------"

total_ram=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
free_ram=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')
used_ram=$((total_ram - free_ram))
ram_usage_percent=$(( (used_ram * 100) / total_ram ))

total_ram_mb=$((total_ram / 1024))
used_ram_mb=$((used_ram / 1024))
free_ram_mb=$((free_ram / 1024))

echo "Total RAM: ${total_ram_mb} MB"
echo "Used RAM: ${used_ram_mb} MB"
echo "Free RAM: ${free_ram_mb} MB"
echo "RAM Usage: ${ram_usage_percent}%"
echo "========================================="

echo "[$times] - Fragment Usage [$ram_usage_percent%] - Fragment Count [$used_ram_mb MB] - Details [Total: $total_ram_mb MB, Available: $free_ram_mb MB]" >> "$FRAG_LOG"
```

## g. “On Fate's Approach”

Menambahkan shell manager.sh yang berada di lokasi ./scripts/manager.sh
```bash
$ nano manager.sh
```
Option yang harus ada diantaranya Add/Remove CPU [Core] Usage, Add/Remove RAM [Fragment] Usage, View Active Jobs
```
#!/bin/bash

CORE_SCRIPTS="./scripts/core_monitor.sh"
FRAG_SCRIPTS="./scripts/frag_monitor.sh"

show_menu() {
    echo "--------------------------------------------"
    echo "              CRONTAB MANAGER      "
    echo "--------------------------------------------"
    echo "1. Add CPU [Core] Usage Monitoring"
    echo "2. Remove CPU [Core] Usage Monitoring"
    echo "3. Add RAM [Fragment] Usage Monitoring"
    echo "4. Remove RAM [Fragment] Usage Monitoring"
    echo "5. View Active Cron Jobs"
    echo "6. Exit"
    echo "--------------------------------------------"
    echo -n "Enter option [1-6]: "
}

add_cron_job() {
    local script_data="$1"
    local job_command="* * * * * /bin/bash $script_data"

    if crontab -l | grep -q "$script_data"; then
        echo "Error: Monitoring for $script_data is already active!"
    else
        (crontab -l 2>/dev/null; echo "$job_command") | crontab -
        echo "Successfully added monitoring for $script_data!"
    fi
}

remove_cron_job() {
    local script_data="$1"

    if crontab -l | grep -q "$script_data"; then
        crontab -l | grep -v "$script_data" | crontab -
        echo "Successfully removed monitoring for $script_data!"
    else
        echo "Error: No monitoring found for $script_data!"
    fi
}

view_active_jobs() {
    echo "Current active cron jobs:"
    crontab -l
}

while true; do
    show_menu
    read option
    case $option in
        1) add_cron_job "$CORE_SCRIPTS" ;;
        2) remove_cron_job "$CORE_SCRIPTS" ;;
        3) add_cron_job "$FRAG_SCRIPTS" ;;
        4) remove_cron_job "$FRAG_SCRIPTS" ;;
        5) view_active_jobs ;;
        6) echo "Exiting Crontab Manager."; exit 0 ;;
        *) echo "Invalid option! Please enter a number between 1-6." ;;
    esac
done
```
Add/Remove CPU [Core] Usage
```bash
add_cron_job() {
    local script_data="$1"
    local job_command="* * * * * /bin/bash $script_data"

    if crontab -l | grep -q "$script_data"; then
        echo "Error: Monitoring for $script_data is already active!"
    else
        (crontab -l 2>/dev/null; echo "$job_command") | crontab -
        echo "Successfully added monitoring for $script_data!"
    fi
}
```
```bash
remove_cron_job() {
    local script_data="$1"

    if crontab -l | grep -q "$script_data"; then
        crontab -l | grep -v "$script_data" | crontab -
        echo "Successfully removed monitoring for $script_data!"
    else
        echo "Error: No monitoring found for $script_data!"
    fi
}
```

## h. “The Disfigured Flow of Time”

Membuat 2 log file di folder logs
```bash
$ mkdir logs && cd logs && touch core.log fragment.log
```
Menghubungkan ke masing-masing monitoring dengan output format yang sudah ditentukan

Menghubungkan ke core_monitor.sh dengan output format [YYYY-MM-DD HH:MM:SS] - Core Usage [$CPU%] - Terminal Model [$CPU_Model]
```bash
LOG_DIR="logs"
CORE_LOG="$LOG_DIR/core.log"

mkdir -p "$LOG_DIR"
```
Menmbuat format ouput 
```bash
times=$(date +"%Y-%m-%d %H:%M:%S")
```
```bash
echo "[$times] - Core Usage [$cpu_usage%] - Terminal Model [$cpu_model]" >> "$CORE_LOG"
```
Menghubungkan ke frag_monitor.sh dengan format output [YYYY-MM-DD HH:MM:SS] - Fragment Usage [$RAM%] - Fragment Count [$RAM MB] - Details [Total: $TOTAL MB, Available: $AVAILABLE MB]
```bash
LOG_DIR="logs"
FRAG_LOG="$LOG_DIR/fragment.log"

mkdir -p "$LOG_DIR"
```
Membuat format output
```bash
times=$(date +"%Y-%m-%d %H:%M:%S")
```
```bash
echo "[$times] - Fragment Usage [$ram_usage_percent%] - Fragment Count [$used_ram_mb MB] - Details [Total: $total_ram_mb MB, Available: $free_ram_mb MB]" >> "$FRAG_LOG"
```

## i. “Irruption of New Color”

Membuat shell script terminal.sh untuk menghubungkan semua shell scripts yang lokasinya berada di luar folder scripts
```bash
$ nano terminal.sh
```
Dengan struktur menu terdapat Register, Login (Crontab manager (add/rem core & fragment usage) Exit), Exit
```bash
#!/bin/bash

DATABASE="data/player.csv"

show_main_menu() {
    clear
    echo "-------------------------------"
    echo "|            ARCAEA           |"
    echo "-------------------------------"
    echo "| ID |         OPTION         |"
    echo "|----|------------------------|"
    echo "|  1 | Register               |"
    echo "|  2 | Login                  |"
    echo "|  3 | Exit                   |"
    echo "-------------------------------"
    echo -n "Enter option [1-3]: "
    read option

    case $option in
        1) register_user ;;
        2) login_user ;;
        3) exit 0 ;;
        *) echo "Invalid option. Try again."; sleep 2; show_main_menu ;;
    esac
}

register_user() {
    echo -n "Enter your email: "
    read email
    echo -n "Enter your username: "
    read username
    echo -n "Enter password: "
    read -s password
    echo ""

    ./register.sh "$email" "$username" "$password"
    echo "Press Enter to continue..."
    read
    show_main_menu
}

login_user() {
    echo -n "Enter your email: "
    read email
    echo -n "Enter password: "
    read -s password
    echo ""

    ./login.sh "$email" "$password"
    if [ $? -eq 0 ]; then
        show_login_info
        show_login_menu
    else
        echo "Login failed. Please try again."
        echo "Press Enter to continue..."
        read
        show_main_menu
    fi
}

show_login_info() {
    clear
    echo "==================================="
    echo "           LOGIN SUCCESS           "
    echo "==================================="

    ./scripts/core_monitor.sh
    ./scripts/frag_monitor.sh

    echo "Press Enter to continue..."
    read
}

show_login_menu() {
    clear
    echo "-------------------------------"
    echo "            ARCAEA             "
    echo "-------------------------------"
    echo "| ID |         OPTION         |"
    echo "|----|------------------------|"
    echo "|  1 | Crontab Manager        |"
    echo "|  2 | Exit                   |"
    echo "-------------------------------"
    echo -n "Enter option [1-2]: "
    read option

    case $option in
        1) show_crontab ;;
        2) show_main_menu ;;
        *) echo "Invalid option. Try again."; sleep 2; show_login_menu ;;
    esac
}

show_crontab() {
    ./scripts/manager.sh
    echo "Press Enter to continue..."
    read
    show_login_menu
}

show_main_menu
```

## Beberapa ERROR pada soal ini

Tidak terdapat direktori dan file dari logs/core.log saat menjalankan ./core_monitor.sh.
![Image](https://github.com/user-attachments/assets/90bef386-af2d-418a-b93d-13c3ca5e137a)
Solusi: Menambahkan command ini ke dalam core_monitor.sh dan frag_monitor.sh.
```bash
$ mkdir -p "LOG_DIR"
```

Kurang dalam menambahkan kata "fi" setelah fungsi if else berakhir.
![Image](https://github.com/user-attachments/assets/814ac9fb-fd97-4f70-88f5-01d82019ece9)
Solusi: Menambahkan kata fi pada saat if else berakhir.

Waktu saat ini tidak muncul pada output fragment.log.
![Image](https://github.com/user-attachments/assets/ac4afd8b-36fc-4075-9014-9922864c2903)
Peyebabnya adalah perbedaan penaaman variabel times pada frag_monitor.sh.

Kurang dalam menambahkan kata "esac" setelah fungsi case option berakhir
![Image](https://github.com/user-attachments/assets/7bf70497-dab0-4a1b-a208-189e7a07785e)
Solusi: menambahkan kata "esac" setelah case option berakhir.

Tidak dapat menajalankan frag_monitor.sh jikan menajalankan core_monitor.sh.
![Image](https://github.com/user-attachments/assets/626d01db-7f45-4b5a-8dde-13b333191533)
Solusi: menghapus ./scripts pada ./scripts/frag_monitor.sh yang terdapat pada shell scripts core_monitor.sh dan membuat command.
```bash
./frag_monitor.sh
```

## Revisi Soal 2

Tidak dapat menajalankan frag_monitor.sh setelah menajalankan core_monitor.sh.
![Image](https://github.com/user-attachments/assets/626d01db-7f45-4b5a-8dde-13b333191533)
Solusi: menghapus ./scripts pada ./scripts/frag_monitor.sh yang terdapat pada shell scripts core_monitor.sh dan membuat command. Hal tersebut terjadi karena shell scripts frag_monitor.sh sudah berada pada folder yang sama sehingga tidak perlu mendefinisikan ./scripts lagi.
```bash
./frag_monitor.sh
```









# Soal 3 modul 1 sisop

install text editor seperti gedit
![Image](https://github.com/user-attachments/assets/b11c296e-2ec3-477b-9324-8812b9556db7)
masuk ke gedit
![Image](https://github.com/user-attachments/assets/a7956ab5-0fd6-48bd-99b3-76e0c488a967)
memberi dsotm.sh access untuk execute
![Image](https://github.com/user-attachments/assets/d8740d18-9013-4320-b25c-dfa84d8f91e7)
a. install jq
![Image](https://github.com/user-attachments/assets/f1596016-9f28-4e76-878c-f04926ce468b)
install curl
![Image](https://github.com/user-attachments/assets/9397fb33-c39c-47df-bdd4-9212b4ee6bae)
melihat refrensi dari link
![Image](https://github.com/user-attachments/assets/8c1ffd7e-1b60-47f3-aa02-98d56fec21d9)
membuat kodingan
![Image](https://github.com/user-attachments/assets/c27e8c97-c706-417a-be39-9e2a35a7f1f4)
menjalankan kodingan
![Image](https://github.com/user-attachments/assets/409fe6d4-0dec-426d-850c-25992a67e379)
hasil kodingan
https://github.com/user-attachments/assets/ab4b9fb0-8e54-4318-8aa6-89a293f65f44

b. mencari refrensi
![Image](https://github.com/user-attachments/assets/3d82935a-6e90-4d22-afc4-022614ba78e0)
membuat kodingan
![Image](https://github.com/user-attachments/assets/ccc1b28e-1a48-4b2a-be3c-a08ef8aefbbd)
menjalankan kodingan
![Image](https://github.com/user-attachments/assets/81031b16-8123-4e93-a4f9-16d2fa12e6d6)
hasil kodingan
![Image](https://github.com/user-attachments/assets/a0328323-7542-4b13-93d5-8b13e470b9f5)
c. Membuat kodingan
![Image](https://github.com/user-attachments/assets/1bf92224-d790-44c1-8b14-2d1b83889d83)
menjalankan kodingan
![Image](https://github.com/user-attachments/assets/ef58cd2f-6799-4449-a842-0c723a1dc421)
error
![Image](https://github.com/user-attachments/assets/f33232d8-b066-42f1-a920-ba57a03b5616)
perbaikan kodingan
![Image](https://github.com/user-attachments/assets/8c0383f6-af69-4f1d-9f96-ff1b6f37733e)
menjalankan revisi kodingan
![Image](https://github.com/user-attachments/assets/ef58cd2f-6799-4449-a842-0c723a1dc421)
hasil kodingan
https://github.com/user-attachments/assets/27817664-2b52-473c-ba35-126d8aceb356

d. mencari refrensi
![Image](https://github.com/user-attachments/assets/b5c552fd-1cdb-49b5-b655-09325cef78d8)
![Image](https://github.com/user-attachments/assets/34c27995-6f1d-48e4-a548-ce9f55d1236c)
membuat kodingan
![Image](https://github.com/user-attachments/assets/fe23f4ca-cbd2-4f16-b5e6-55ad12fdc9c8)
menjalankan kodingan
![Image](https://github.com/user-attachments/assets/cef0c296-662f-4fd6-9257-fd1a10a11d6f)
hasil
https://github.com/user-attachments/assets/3de6bc35-af02-4686-858e-de4662534f7f

e. membuat kodingan
![Image](https://github.com/user-attachments/assets/4818bec7-624f-4688-beb8-b0f3595abe20)
menjalankan kodingan
![Image](https://github.com/user-attachments/assets/35366164-d93e-4aa6-9e9a-bade7d32e5e1)
hasil
![Image](https://github.com/user-attachments/assets/bd4fd34d-51c8-436e-b70a-67376c51b2d2)
membuat case untuk nanti cara dijalankan
![Image](https://github.com/user-attachments/assets/c73fa09c-b0d7-455e-80cc-494b792d4b87)
