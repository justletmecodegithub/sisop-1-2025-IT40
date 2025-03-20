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

- `DATABASE="data/player.csv"` ini berfungsi untuk sebagai tempat dimana output akan disimpan.
- `email="$1", username="$2", password="$3"` berfungsi untuk menyimpan parameter satu sampai 3 ke dalam variabel tersebut.
- `echo "$email,$username,$hashed_password" >> "$DATABASE"` mengirimkan output ke database.

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

Email harus memiliki format yang benar dengan tanda @ dan titik yang dapat dibuat menggunakan regex berikut
```bash
valid_email() {
    local email="$1"
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}
```
Kemudian kita mengecek format email yang digunakan
```bash
if ! valid_email "$email"; then
    echo "Error: Invalid email format."
    exit 1
fi
```
Password harus memiliki minimal 8 karakter, setidaknya satu huruf kecil, satu huruf besar, dan satu angka yang dapat dibuat melalui regex 
```bash
valid_password() {
    local password="$1"
    [[ ${#password} -ge 8 && "$password" =~ [a-z] && "$password" =~ [A-Z] && "$password" =~ [0-9] ]]
}
```
Kemudian kita mengecek format pasword
```bash
if ! valid_password "$password"; then
    echo "Error: Password must be at least 8 characters, include uppercase, lowercase, and a number."
    exit 1
fi
```

## c. “Unceasing Spirit”

Jadikan sistem login/register tidak bisa memakai email yang sama (email = unique)

Pada register.sh kita menggunakan
```bash
if grep -q "^$email," "$DATABASE"; then
    echo "Error: Email already registered!"
    exit 1
fi
```
Pada login.sh kita menggunakan
```bash
if ! grep -q "^$email," "$DATABASE"; then
    echo "Error: Email not registered!"
    exit 1
fi
```
- Perbedaan pada kedua kode di atas terletak pada penggunaan `!` pada login.sh dan tidak ada pada register.sh. Tanda `!` pada login.sh berfungsi untuk membalikkan hasil pencarian, jadi kode `if` akan dijalankan jika email tidak ditemukan.

## d. “The Eternal Realm of Light”

Menggunakan algoritma hashing sha256sum yang memakai static salt untuk menjaga keamanan password. 

Pada register.sh dan login.sh dapat menambahkan kode ini
```bash
STATIC_SALT="ArcaeaSecretPassword"
```
```bash
hashed_password=$(echo -n "${STATIC_SALT}${password}" | sha256sum | awk '{print $1}')
```
Tambahan koed untuk login.sh yang berfungsi membandingkan hash password saat login dengan hash password yang ada di database
```bash
data_hash=$(awk -F ',' -v email="$email" '$1 == email {print $3}' "$DATABASE")

if [ "$hashed_password" == "$data_hash" ]; then
    echo "Login successful!"
else
    echo "Error: Incorrect password!"
    exit 1
fi
```
### Contoh output dari hashing menggunakan Static Salt
![Image](https://github.com/user-attachments/assets/b6f4275b-e1fa-4721-8931-0c83ee8e6aea)

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
- `cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')` digunakan untuk menghitung penggunaan CPU dengan persentase yang di mana ini akan mencari kata cpu yang terdapat pada file `/proc/tat` pada sistem linux kita.
- `cpu_model=$(grep "model name" /proc/cpuinfo | awk -F ':' 'NR==1 {print $2}'| awk '{$1=$1; print}')` digunakan untuk mengetahui CPU model yang kita gunakan yang dicari melalui kata model name yang ada di `/proc/cpuinfo`.

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
- `total_ram=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')` digunakan untuk menghitung total RAM yang kita miliki melalui kata MemTotal yang ada di /proc/meminfo.
- `free_ram=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')` digunakan untuk mengetahui RAM yang bisa kita gunakan untuk saat ini melalui kata MemAvailable yang terdapat pada /proc/meminfo.
- `used_ram=$((total_ram - free_ram))` menghitung peggunaan RAM kita.
- `ram_usage_percent=$(( (used_ram * 100) / total_ram ))` menghitung persentase penggunaan RAM
- `total_ram_mb=$((total_ram / 1024))` mengubah total RAM ke ukuran MB.
- `used_ram_mb=$((used_ram / 1024))` mengubah penggunaan RAM ke ukuran MB.
- `free_ram_mb=$((free_ram / 1024)` mengubah jumlah RAM yang dapat kita gunakan ke MB.

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
- `CORE_SCRIPTS="./scripts/core_monitor.sh"` memudahkan untuk pemanggilan shell script core_monitor.sh
- `FRAG_SCRIPTS="./scripts/frag_monitor.sh"` memudahkan untuk pemanggilan shell script frag_monitor.sh
  
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
-`add_cron_job()` menambahkan cron job pada setiap script dengan menggunakan `local job_command="* * * * * /bin/bash $script_data"` yang berarti akan berjalan setiap menit. Dan disini juga kita akan mengecek apakah sudah terdapat cron job yang aktif sebelumnya.

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
- `remove_cron_job()` menghapus cron job yang sudah aktif sebelumnya.


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
#### Output yang dihasilkan dari format di atas pada core.log
![Image](https://github.com/user-attachments/assets/30a1e5f9-4379-4999-92eb-16dc8b1d9b27)

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
#### Output yang dihasilkan dari kode di atas pada file fragment.log
![Image](https://github.com/user-attachments/assets/ccddb3e8-f34b-4b49-8a70-86d876dd32a0)

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
- `show_main_menu()` menampilkan menut utama pada saat menjalankan scripts.
- `register_user()` fungsi yang akan ditamplkan pada saat memilih option register dan kemudian ini akan terhubung dengan script `register.sh`.
- `login_user()` fungsi yang akan ditampilkan pada saat memilih option login dan kemudian akan menjalankan scripts `login.sh`.
- `show_login_info()` fungsi yang akan muncul jika sudah berhasil login dan kemudian akan memanggil script `core_monitor.sh` dan `frag_monitor.sh`.
- `show_login_menu()` fungsi yang akan muncul setelah menekan enter pada `show_login_info()`.
- `show_crontab()` menjalankan script `manager.sh`.

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

Tidak dapat menajalankan frag_monitor.sh setelah menjalankan core_monitor.sh.
![Image](https://github.com/user-attachments/assets/626d01db-7f45-4b5a-8dde-13b333191533)
Solusi: menghapus ./scripts pada ./scripts/frag_monitor.sh yang terdapat pada shell scripts core_monitor.sh dan membuat command.
```bash
./frag_monitor.sh
```

## Revisi Soal 2

Tidak dapat menajalankan frag_monitor.sh setelah menajalankan core_monitor.sh.
![Image](https://github.com/user-attachments/assets/626d01db-7f45-4b5a-8dde-13b333191533)
Solusi: menghapus ./scripts pada ./scripts/frag_monitor.sh yang terdapat pada shell scripts core_monitor.sh dan membuat command. Hal tersebut terjadi karena shell scripts frag_monitor.sh sudah berada pada folder yang sama sehingga tidak perlu mendefinisikan ./scripts lagi.
Kode sebelum revisi
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
Kemuudian mengganti pemanggilan frag_monitor.sh dengan ini
```bash
./frag_monitor.sh
```
Kode akhir setelah di revisi
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

./frag_monitor.sh
```









# Soal 3 modul
membuat script dengan fungsi-fungsi yang dijalankan dengan cara ./dsotm.sh --play=”<Track>” dengan Track sebagai nama nama lagu yang dipilih.
- a. lagu `speak to me` menampilkan afirmasi positif secara terus-menerus.
- b. lagu `on the run` menampilkan progres bar di terminal yang berjalan secara dinamis hingga mencapai 100%.
- c. lagu `time` menampilkan waktu saat ini secara real-time di terminal dan memperbaruinya setiap detik.
- d. lagu `money` membuat efek "hujan uang" di terminal dengan karakter simbol mata uang yang turun secara acak dari atas ke bawah, mirip dengan efek "hujan kode" dalam film The Matrix.
- e. lagu `brain damage`menampilkan proses-proses yang menggunakan CPU tertinggi dalam sistem secara real-time.
  
install text editor seperti `gedit`
```bash
$ sudo apt install gedit
```
![Image](https://github.com/user-attachments/assets/b11c296e-2ec3-477b-9324-8812b9556db7)
untuk text editor yang saya pakai untuk pengerjaan soal ini adalah `gedit` maka diperlukan penginstallan terlebih dahulu

memberi dsotm.sh access untuk execute
```bash
$ chmod +x dsotm.sh
```
dibutuhkan access execute untuk bisa menjalankan Bash maka menamabahkan access pada modifier dengan `chmod +x`

masuk ke gedit
```bash
$ gedit dsotm.sh
```
## a. Speak to Me
install `jq`
```bash
$ sudo apt install jq
```
![Image](https://github.com/user-attachments/assets/f1596016-9f28-4e76-878c-f04926ce468b)
`jq `diperlukan untuk mengestrak teks dari JSON respon API

install `curl`
```bash
$ sudo apt install curl
```
![Image](https://github.com/user-attachments/assets/9397fb33-c39c-47df-bdd4-9212b4ee6bae)
`curl` diperlukan untuk mentransfer data pada link ke terminal

CODE
```bash
#!/bin/bash

clear

speak_to_me() {
    while true; do
        clear
        curl -s https://www.affirmations.dev | jq -r '.affirmation'
        sleep 1
    done
}
```
- program `clear` membersihkan tampilan pada layar
- pada fungsi `speak_to_me` terdapat `while true; do` membuat infinite loop untuk menampilkan kata afirmasi, `clear` Membersihkan layar terminal agar hanya satu afirmasi tampil pada satu waktu, Mengambil data dari API https://www.affirmations.dev menggunakan `curl -s`, menggunakan `-s` mencegah tampilan progres atau error dari `curl`, `jq -r` digunakan untuk mengekstrak hanya teks afirmasi dari respons JSON, `sleep 1` membuat program menunggu selama 1 detik sebelum mengambil afirmasi berikutnya

menjalankan kodingan
![Image](https://github.com/user-attachments/assets/409fe6d4-0dec-426d-850c-25992a67e379)
hasil kodingan
https://github.com/user-attachments/assets/ab4b9fb0-8e54-4318-8aa6-89a293f65f44

## b. On the Run
CODE
```bash
on_the_run()  {
	local progress=0
    local bar_length=$(tput cols)
    local filled

    while [ "$progress" -lt 100 ]; do
        clear
        filled=$(( progress * bar_length / 100 ))
        printf "["
        printf "%0.s#" $(seq 1 $filled)
        printf "%0.s-" $(seq $filled $bar_length)
        printf "] %d%%\n" "$progress"
        progress=$(( progress + RANDOM % 10 + 1 ))
        sleep $(awk -v min=0.1 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
}
```
- menginisialisasi variabel untuk tracking progres dan menentukan panjang progress bar sesuai lebar terminal.`local progress=0` Variabel progress dimulai dari 0, `bar_length=$(tput cols)` Mengambil lebar terminal dalam jumlah kolom , `filled `  Variabel untuk menyimpan jumlah karakter '#' yang terisi dalam progress bar
- untuk menampilkan tampilan progress bar. Menggunakan loop untuk terus memperbarui progress bar hingga mencapai 100%. Jumlah karakter '#' dihitung berdasarkan persentase progress.`while [ "$progress" -lt 100 ]; do`   Looping selama progress kurang dari 100%, `filled=$(( progress * bar_length / 100 )) ` Menghitung berapa banyak karakter '#' yang harus ditampilkan
-  `printf "%0.s#" $(seq 1 $filled)`  Mencetak '#' sebanyak `filled` kali (menunjukkan progress yang telah dicapai), `"%0.s-" $(seq $filled $bar_length)`  Mencetak '-' untuk sisa progress bar yang belum terisi, `"] %d%%\n" "$progress"`  Menampilkan persentase progress di samping progress bar
-`progress=$(( progress + RANDOM % 10 + 1 ))` Progress akan bertambah secara acak antara 1% hingga 10% pada setiap iterasi, memberikan efek progres yang tidak monoton
- `sleep $(awk -v min=0.1 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')`Menambahkan jeda acak antara 0.1 hingga 1 detik sebelum progres bar diperbarui, memberikan efek variasi waktu antara setiap update 

## c. Time
CODE
```bash
time_Display() {
    while true; do
        clear
        date "+%Y-%m-%d %H:%M:%S"
        sleep 1
    done
}
```
-menggunakan fungsi `time_Display()` karena jika menggunakan `time` adalah salah satu command di linux untuk memperlihatkan waktu yang dibutuhkan untuk mengesekusi command lain yang berarti jika menggunakan `time` akan terjadi error.
![Image](https://github.com/user-attachments/assets/f33232d8-b066-42f1-a920-ba57a03b5616)

-menampilkan waktu `date "+%Y-%m-%d %H:%M:%S"` dengan format: `%Y` tahun, `%m` bulan, `%d` tanggal, `%H` jam, `%M` menit, `%S` detik.

## d. Money
CODE
```bash
money() {
	chars=("💲" "€" "£" "¥" "¢" "₹" "₩" "₿" "₣")
	rows=$(tput lines)
	cols=$(tput cols)
	while true; do
    col=$((RANDOM % cols))  # Pick a random column
    char=${chars[$((RANDOM % ${#chars[@]}))]}  # Pick a random character
    tput cup 0 $col  # Move cursor to the top of the column
    echo -ne "\033[32m$char\033[0m"  # Print the character in green

    for ((i=1; i<rows; i++)); do
        tput cup $i $col
        echo -ne "\033[32m$char\033[0m"
        sleep 0.1
    done
done
}
```
-Array `chars` berisi berbagai simbol mata uang internasional, seperti dolar (💲), euro (€), pound (£), yen (¥), dan sebagainya.
-Mengambil jumlah baris `(rows)` dan kolom `(cols)` terminal menggunakan `tput`.
-`col=$((RANDOM % cols))` Memilih kolom acak (col) dalam rentang 0 hingga cols - 1, ` char=${chars[$((RANDOM % ${#chars[@]}))]}`Memilih simbol mata uang secara acak dari array,  `tput cup 0 $col`Memindahkan kursor ke baris 0 (atas) pada kolom yang dipilih secara acak, Mencetak simbol mata uang di terminal dengan warna hijau `(\033[32m)`.
menjalankan kodingan
![Image](https://github.com/user-attachments/assets/cef0c296-662f-4fd6-9257-fd1a10a11d6f)
hasil
https://github.com/user-attachments/assets/3de6bc35-af02-4686-858e-de4662534f7f

## e. Brain Damage
```bash
brain_damage() {
    while true; do
        clear
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 20
        sleep 1
    done
}

```
-Menjalankan perintah `ps` untuk menampilkan daftar proses berdasarkan penggunaan CPU tertinggi.

`ps -eo pid,comm,%cpu,%mem` Menampilkan daftar proses dengan informasi berikut:

`pid` Process ID (ID proses).
`comm` Nama perintah yang menjalankan proses.
`%cpu` Penggunaan CPU dalam persentase.
`%mem` Penggunaan memori dalam persentase.
`--sort=-%cpu` Mengurutkan daftar proses berdasarkan penggunaan CPU dari yang terbesar ke terkecil (- berarti descending).

`head -n 20` Menampilkan hanya 20 proses dengan penggunaan CPU tertinggi.

## membuat case untuk nanti cara dijalankan
```bash
case "$1" in
    --play="Speak to Me")
        speak_to_me
        ;;
    --play="On the Run")
        on_the_run
        ;;
    --play="Time")
        time_Display
        ;;
    --play="Money")
        money
        ;;
    --play="Brain Damage")
        brain_damage
        ;;
    *)
        echo "Usage: ./dsotm.sh --play=\"<Track>\""
        echo "Available Tracks: Speak to Me, On the Run, Time, Money, Brain Damage"
        exit 1
        ;;
esac
```
dengan format `./dsotm.sh --play="<track>"` jika argumen yang cocok program akan menjalankan fungsi yang sesuai

jika argumen tidak sesuai maka akan memperlihatkan
```bash
echo "Usage: ./dsotm.sh --play=\"<Track>\""
 echo "Available Tracks: Speak to Me, On the Run, Time, Money, Brain Damage"
```
## hasil CODE
a.

Menjalankan argumen
```bash
$ ./dsotm.sh --play="Speak to Me"
```
hasil kodingan
https://github.com/user-attachments/assets/ab4b9fb0-8e54-4318-8aa6-89a293f65f44

b.

Menjalankan argumen
```bash
$ ./dsotm.sh --play="On the Run"
```
hasil kodingan
![Image](https://github.com/user-attachments/assets/a0328323-7542-4b13-93d5-8b13e470b9f5)

c.

Menjalankan argumen
```bash
$ ./dsotm.sh --play="Time"
```
hasil kodingan
https://github.com/user-attachments/assets/27817664-2b52-473c-ba35-126d8aceb356

d.

Menjalankan argumen
```bash
$ ./dsotm.sh --play="Money"
```
hasil
https://github.com/user-attachments/assets/3de6bc35-af02-4686-858e-de4662534f7f

e.

Menjalankan argumen
```bash
$ ./dsotm.sh --play="Brain Damage"
```
hasil
![Image](https://github.com/user-attachments/assets/bd4fd34d-51c8-436e-b70a-67376c51b2d2)

## revisi Soal
pada subsoal b progress bar tidar terjadi hanya pada 1 baris terminal dan juga progress bar tidak mencapai 100%
```bash
on_the_run() {
    local progress=0
    local bar_length=50 
    
    while [ "$progress" -le 100 ]; do
        local filled=$(( progress * bar_length / 100 ))
        
        printf "\r["
        printf "%0.s#" $(seq 1 $filled)
        printf "%0.s-" $(seq $filled $bar_length)
        printf "] %d%%" "$progress"
        
        progress=$(( progress + RANDOM % 10 + 1 ))
        
        if [ "$progress" -gt 100 ]; then
            progress=100
        fi

        sleep $(awk -v min=0.1 -v max=0.5 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
```
`local bar_length=50` membuat panjang bar bisa tercangkup pada satu baris saja dan 
`if [ "$progress" -gt 100 ]; then
            progress=100
        fi` membatasi progress bar hingga maksimal 100%

hasil Revisi
![Screenshot 2025-03-20 232748](https://github.com/user-attachments/assets/be100871-e219-4697-b871-6f8da9972958)
