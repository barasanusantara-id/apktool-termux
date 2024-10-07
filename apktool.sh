#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear

cek_dan_download() {
    if ! dpkg -s $1 &> /dev/null; then
        echo -e "${YELLOW}[*] Menginstal $1...${NC}"
        pkg install $1 -y
    else
        echo -e "${GREEN}[*] $1 sudah terinstal. Melewati instalasi.${NC}"
    fi
}

echo
cek_dan_download openjdk-17
cek_dan_download wget
cek_dan_download tar
echo

echo -e "${YELLOW}Pilih versi APKTool yang ingin diinstal:${NC}"
echo "1) Bawaan (2.10.0)"
echo "2) Manual"
echo
read -p "Pilih [1-2]: " pilihan
echo

case $pilihan in
    1)
        version="2.10.0"
        ;;
    2)
        read -p "Masukkan versi APKTool yang ingin diunduh: " version
        ;;
    *)
        echo -e "${RED}Pilihan tidak valid!${NC}"
        exit 1
        ;;
esac

echo
echo -e "${YELLOW}[*] Mengunduh script APKTool...${NC}"
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -O apktool
echo

echo -e "${YELLOW}[*] Memeriksa ketersediaan APKTool versi $version...${NC}"
url="https://github.com/iBotPeaches/Apktool/releases/download/v$version/apktool_$version.jar"
if wget --spider "$url" 2>/dev/null; then
    echo -e "${GREEN}[*] APKTool versi $version ditemukan, Mengunduh...${NC}"
    wget "$url" -O apktool.jar
else
    echo -e "${RED}[!] APKTool versi $version tidak ditemukan, Pastikan versi tersedia.${NC}"
    exit 1
fi
echo

echo -e "${YELLOW}[*] Menyiapkan APKTool...${NC}"
chmod +x apktool
mv apktool $PREFIX/bin/
mv apktool.jar $PREFIX/bin/apktool.jar
echo

echo -e "${YELLOW}[*] Menguji APKTool...${NC}"
apktool
echo

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[*] APKTool berhasil diinstal!${NC}"
else
    echo -e "${RED}[!] APKTool gagal diinstall.${NC}"
fi
