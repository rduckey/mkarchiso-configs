# mkarchiso-configs <br/> _Reusable profiles & tooling for custom Arch ISO builds_

[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org)
[![mkarchiso](https://img.shields.io/badge/builder-mkarchiso-black)](https://github.com/archlinux/archiso)
[![Shell](https://img.shields.io/badge/language-Shell-blue)](#)

---

## 📌 Project Description

**mkarchiso-configs** is a collection of modular **build profiles** and **helper tools** for producing customized Arch Linux live media (ISOs) using `mkarchiso`.  
Use it to create rescue/recovery media, workstation installers, or purpose-built toolkits—BIOS or UEFI.

**Highlights**
- 🔧 Multiple profiles under `configs/` with their own `packages.x86_64`, overlays, and boot assets.
- 🧩 Clean templates under `templates/` to bootstrap new profiles quickly.
- 🛠️ Utilities under `tools/` to standardize build, test (QEMU), and packaging workflows.
- 🧱 Makefile entry points (when available) to wrap common `mkarchiso` invocations.

---

## 🗂️ Repository Layout

