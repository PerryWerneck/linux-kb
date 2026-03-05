#!/bin/bash

if [ -d "/run/media/perry/Transporte500/backup" ]; then

	echo "Backup para disco externo"
	rsync \
		--verbose \
		--human-readable \
		--compress \
		--recursive \
		--dirs \
		--inplace \
		--delete \
		--delete-excluded \
		--archive \
		--chown=perry:perry \
		--chmod=D755,F644 \
		--exclude='.cache' \
		--exclude='Downloads' \
		--exclude='project/files' \
		--exclude='.minikube/cache' \
		--exclude='.wine' \
		--exclude='libvirt' \
		--exclude='*.old' \
		--exclude='*.iso' \
		--exclude='.config/Code/Cache*' \
		--exclude='.config/Microsoft/Microsoft Teams/*Cache' \
		--exclude='.config/Microsoft/Microsoft Teams - Insiders/*Cache' \
		--exclude='.teams/.cache' \
		--exclude='.local/share/baloo' \
		--exclude='.local/share/akonadi' \
		--exclude='.local/share/TelegramDesktop' \
		--exclude='tmp' \
		--exclude='.local/share/gvfs-metadata' \
		--exclude='.config/user-share' \
		--exclude='*/.git/*' \
		~ \
		/run/media/perry/Transporte500/backup

else

	echo "Backup para servidor central"
	rsync \
		--verbose \
		--human-readable \
		--compress \
		--recursive \
		--dirs \
		--inplace \
		--delete \
		--delete-excluded \
		--archive \
		--chown=perry:perry \
		--chmod=D755,F644 \
		--exclude='.cache' \
		--exclude='Downloads' \
		--exclude='project/files' \
		--exclude='.minikube/cache' \
		--exclude='.wine' \
		--exclude='libvirt' \
		--exclude='*.old' \
		--exclude='*.iso' \
		--exclude='.config/Code/Cache*' \
		--exclude='.config/Microsoft/Microsoft Teams/*Cache' \
		--exclude='.config/Microsoft/Microsoft Teams - Insiders/*Cache' \
		--exclude='.teams/.cache' \
		--exclude='.local/share/baloo' \
		--exclude='.local/share/akonadi' \
		--exclude='.local/share/TelegramDesktop' \
		--exclude='tmp' \
		--exclude='.local/share/gvfs-metadata' \
		--exclude='.config/user-share' \
		--exclude='*/.git/*' \
		~ \
		perry@dunga:/home/perry/backup

fi
