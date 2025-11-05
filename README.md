# Arch Linux Install Script: Hyprland + NVIDIA + Zen Kernel

This script automates the **full installation and configuration of Arch Linux**, immediately setting up a modern and high-performance environment based on **Hyprland** and the **NVIDIA proprietary driver**.

It utilizes the **`linux-zen`** kernel package for improved desktop performance and lower latency.

**Author:** `z_kxma`

---

## ✨ Key Features

| Component | Details |
| :--- | :--- |
| **Kernel** | **`linux-zen`** (Performance-oriented kernel) |
| **Graphics** | **NVIDIA Proprietary Drivers** (`nvidia`, `nvidia-utils`, `nvidia-settings`) |
| **Window Manager** | **Hyprland** (Dynamic Tiling Wayland Composer) |
| **Display Manager** | **SDDM** (with `sddm-kcm` for KDE integration) |
| **Bootloader** | **`systemd-boot`** (`bootctl`) |
| **Filesystem** | **Ext4** for `/`, `/home` and **FAT32** for `/boot` |
| **Partitioning**| Fixed sizes: EFI 1G, SWAP 16G, ROOT 50G, HOME 200G |

---

## ⚠️ Warning and Security Notes

### **RISK OF DATA LOSS**

The script uses **`sgdisk -Z "$DISK"`** to wipe the disk and create new partitions. **All data** on the target disk (`/dev/sda` by default) will be **permanently lost**.

* **Verify and change the `DISK="/dev/sda"` variable** at the beginning of the script if your target drive is different (e.g., `/dev/nvme0n1`).

### **Default Passwords**

The script uses default insecure passwords defined within the script:

* **`PASSWORD="password"`**
* **You must change this password** **before** execution in the script, or immediately after installation for both the **`root`** user and the **`archuser`** user.

---

## 🚀 Installation Guide

### 1. Prerequisites

1.  **Arch Linux Live ISO:** Boot from the official Arch Linux installation medium.
2.  **Internet Connection:** Ensure you have an active internet connection in the live environment.
3.  **Drive:** The **target drive** must be `/dev/sda` or the `DISK` variable must be adjusted accordingly.

### 2. Download and Run the Script

Execute the following commands in the Arch Live Environment shell:

```bash
# Download the script
git clone https://github.com/zKxma/Arch-Linux.git
cd /Arch-Linux

# Make the script executable
chmod +x install.sh

# Run the script
./install.sh
