# === Configuration ===
PROJECT_DIR := $(CURDIR)
RELENG_DIR  := $(PROJECT_DIR)/releng
OUT_DIR     := $(PROJECT_DIR)/out
ISO_NAME    := archlinux-recovery.iso

# === Targets ===

## Build the ISO using mkarchiso
build:
	@echo "🔨 Building ISO..."
	sudo mkarchiso -v -w $(RELENG_DIR)/work -o $(OUT_DIR) $(RELENG_DIR)
	@echo "✅ ISO built at $(OUT_DIR)"

## Clean build artifacts
clean:
	@echo "🧹 Cleaning build directory..."
	sudo rm -rf $(RELENG_DIR)/work $(OUT_DIR)
	@echo "✅ Cleaned."

## Test ISO in headless QEMU
test:
	@echo "🧪 Booting ISO in QEMU..."
	qemu-system-x86_64 \
		-m 4096 \
		-smp 4 \
		-cdrom $(OUT_DIR)/$(ISO_NAME) \
		-enable-kvm \
		-boot d \
		-vga virtio \
		-nic user,model=virtio \
		-no-reboot

## Copy ISO to mounted Ventoy drive
copy-to-ventoy:
	@echo "📤 Copying ISO to Ventoy drive..."
	sudo cp $(OUT_DIR)/$(ISO_NAME) /mnt/ventoy/
	@echo "✅ ISO copied to /mnt/ventoy"

## Full rebuild from scratch
rebuild: clean build

.PHONY: build clean test copy-to-ventoy rebuild
