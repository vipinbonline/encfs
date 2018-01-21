#! /bin/sh
#
# 	Part of kde-service-menu-encfs Version 0.5.2
# 	Copyright (C) 2007-2013 Giuseppe Benigno <giuseppe.benigno(at)gmail.com>
#
# 	This program is free software: you can redistribute it and/or modify
# 	it under the terms of the GNU General Public License as published by
# 	the Free Software Foundation, either version 3 of the License, or
# 	(at your option) any later version.
#
# 	This program is distributed in the hope that it will be useful,
# 	but WITHOUT ANY WARRANTY; without even the implied warranty of
# 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# 	GNU General Public License for more details.
#
# 	You should have received a copy of the GNU General Public License
# 	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#source

# ARGUMENTS: "$lang" "$action" "${sourceDir}"										(sourceDir is without final slash "/")
lang=`echo "${1}" | sed -e "s/@//g"` && shift										# en
action="${1}" && shift																# encMountUmountCreate
sourceDir="${1%/}"																	# "/media/cdrom/my secret"
sourceDirName="${sourceDir##*/}"													# "my secret"
destDirName="$(echo "${sourceDirName}" | sed 's/ /_/g')_encfs"						# "my_secret_encfs"
[ -w "${sourceDir%/*}" ] && destDir="${sourceDir%/*}" || destDir="${HOME}"			# if destDir is not writable destDir="/media/cdrom/", otherwise, destDir is $HOME
destDir="${destDir}/${destDirName}"													# /media/cdrom/my_secret_encfs or $HOME/my_secret_encfs

CONFIGDIR="$HOME/.config/kde-service-menu"
CONFIGFILE="${CONFIGDIR}/encfs"
KDIALOG="$(which kdialog)"
FILEMANAGER="$(which dolphin)"

#### languages strings messages #################
#	##For languages as sr@Latn use LANG=srLatn
#	load_language_LANG () {
#		msg_$action="message_text"
#		...
#	}

load_language_ar () {
	msg_error_title="EncFS: خطأ!"
	msg_warning_title="EncFS: تحذير!"
	msg_info_title="EncFS: معلومة"
	msg_config_title="EncFS: إعدادات"
	msg_checkFuseModule="تحقق من تحميل الوحدة fuse"
	msg_checkFusePermission="تحقق من أنك ضمن المجموعة fuse. أكتب في الطرفية: \"sudo adduser $USER fuse\""
	msg_checkDestDir="المعذرة، دليل الوجهة \"${destDir}\" موجود مسبقا!"
	msg_mkDestDir="تعذر إنشاء دليل الوجهة \"${destDir}\""
	msg_askPassword_title="encFS: إدخال كلمة المرور ..."
	msg_askPassword_text="أدخل كلمة المرور لـ \"${sourceDirName}\":"
	msg_mount_abort="تم إلغاء العملية"
	msg_mountError="تعذر ضم دليل الوجهة \"${destDir}\""
	msg_mountError=" \"${destDir}\""
	msg_mount_finish="الدليل \"${sourceDirName}\" ضُم في الدليل \"${destDir}\""
	msg_umount_finish="الدليل \"${destDir}\" أُلغي ضمه وحُذف"
	msg_preCreate="هذا الدليل غير مشفر حاليا، هل تريد تشفيره؟"
	msg_preCreate_cancel="عملية تشفير الدليل \"${sourceDirName}\" قد ألغيت."
	msg_change_password_error="تعذر تغيير كلمة السر لـ \"${sourceDirName}\"!\n فهو ليس ملفا مشفرا بـ encFS"
	msg_change_password_konsole_title="تغيير كلمة السر لـ \"${sourceDirName}\""
	msg_get_information_title="معلومات عن \"${sourceDirName}\""
	msg_get_informations_problem="تعذر الوصول إلى المعلومات .\nتأكد أن \"${sourceDirName}\" دليل مشفر بـ encFS."
	msg_config_cryptMode="نوع التشفير المفضل: (اضغط نعم للمواصلة)"
	msg_config_cryptMode_standard="قياسي، آمن و متوافق."
	msg_config_cryptMode_paranoia="Paranoia، أكثر أمنا لكن أقل توافقية."
	msg_config_autoUnmount="إلغاء ضم تلقائي للدليل؟"
	msg_config_autoUnmount_fm="نعم، بعد غلق  مدير الملفات."
	msg_config_autoUnmount_no="لا، أقوم بها يدويا"
	msg_config_saved="تم حفظ الخيارات."
	msg_save_config_failed="لم يتم حفظ الخيارات!"
}

load_language_de () {
	msg_error_title="encFS Fehler!"
	msg_warning_title="encFS Warnung!"
	msg_info_title="encFS Information"
	msg_config_title="encFS: Konfiguration"
	msg_checkFuseModule="Bitte überprüfen, ob das fuse Modul geladen ist."
	msg_checkFusePermission="Bitte überprüfen, ob Mitgliedschaft in der Gruppe fuse nötig ist. Folgendes shell-Kommando könnte helfen: \"sudo adduser $USER fuse\""
	msg_checkDestDir="Das Zielverzeichnis \"${destDir}\" existiert bereits!."
	msg_mkDestDir="Konnte das Zielverzeichnis \"${destDir}\" nicht erstellen!"
	msg_askPassword_title="encFS: Passphrase eingeben ..."
	msg_askPassword_text="Passphrase für \"${sourceDirName}\" eingeben:"
	msg_mount_abort="Operation abgebrochen."
	msg_mountError="Konnte das Zielverzeichnis \"${destDir}\" nicht einbinden."
	msg_mount_finish="Verzeichnis \"${sourceDirName}\" in \"${destDir}\" eingebunden."
	msg_umount_finish="Einbindung des Verzeichnisses \"${destDir}\" gelöst und Verzeichnis entfernt."
	msg_preCreate="Das Verzeichnis scheint unverschlüsselt, soll es verschlüsselt werden?"
	msg_preCreate_cancel="Verschlüsselung des Verzeichnisses \"${sourceDirName}\" fehlgeschlagen."
	msg_change_password_error="Passphrase von \"${sourceDirName}\" konnte nicht geändert werden!\nKein encFS verschlüsseltes Verzeichnis."
	msg_change_password_konsole_title="Änderung der Passphrase von \"${sourceDirName}\""
	msg_get_information_title="Informationen zu \"${sourceDirName}\""
	msg_get_informations_problem="Keine Informationen gefunden.\nÜberprüpfen, ob \"${sourceDirName}\" ein encFS verschlüsseltes Verzeichnis ist."
	msg_config_cryptMode="Bevorzugte Methode der Verschlüsselung: (OK auswählen um zur nächsten Seite zu gelangen.)"
	msg_config_cryptMode_standard="Standard: sicher und kompatibel."
	msg_config_cryptMode_paranoia="Paranoia: sicherer, aber weniger kompatibel."
	msg_config_autoUnmount="Verzeichniseinbindung automatisch lösen?"
	msg_config_autoUnmount_fm="Ja, nach dem Schließen des Dateimanagers."
	msg_config_autoUnmount_no="Nein, ich löse die Einbindung manuell."
	msg_config_saved="Einstellungen gespeichert."
	msg_save_config_failed="Einstellungen nicht gespeichert!"
}

load_language_en () {
	msg_error_title="encFS error!"
	msg_warning_title="encFS warning!"
	msg_info_title="encFS information"
	msg_config_title="encFS: configuration"
	msg_checkFuseModule="Check if fuse module is loaded"
	msg_checkFusePermission="Check if you need to be in fuse group. From console you can type: \"sudo adduser $USER fuse\""
	msg_checkDestDir="Sorry, destination directory \"${destDir}\" already exists!."
	msg_mkDestDir="Can't create the destination directory \"${destDir}\""
	msg_askPassword_title="encFS: enter passphase ..."
	msg_askPassword_text="Enter passphrase for \"${sourceDirName}\":"
	msg_mount_abort="Operation aborted"
	msg_mountError="Can't mount the destination directory \"${destDir}\""
	msg_mount_finish="Directory \"${sourceDirName}\" mounted in \"${destDir}\""
	msg_umount_finish="Directory \"${destDir}\" umounted and removed"
	msg_preCreate="The directory appears unencrypted, do you want encrypt it?"
	msg_preCreate_cancel="Encryption of directory \"${sourceDirName}\" aborted."
	msg_change_password_error="There are problems changing the password of \"${sourceDirName}\"!\nIt is not an encFS encrypted directory."
	msg_change_password_konsole_title="Changing password of \"${sourceDirName}\""
	msg_get_information_title="Information of \"${sourceDirName}\""
	msg_get_informations_problem="There is a problem getting information.\nCheck if \"${sourceDirName}\" is an encFS encrypted directory."
	msg_config_cryptMode="Preferred crypt mode: (Click OK for next page)"
	msg_config_cryptMode_standard="Standard, secure and compatible."
	msg_config_cryptMode_paranoia="Paranoia, more secure but less compatible."
	msg_config_autoUnmount="Automatically unmount directory?"
	msg_config_autoUnmount_fm="Yes, after closed file manager."
	msg_config_autoUnmount_no="No, I do it manually."
	msg_config_saved="Settings saved."
	msg_save_config_failed="Settings not saved!"
}

load_language_fr () {
	msg_error_title="encFS erreur !"
	msg_warning_title="encFS avertissement !"
	msg_info_title="encFS information"
	msg_config_title="encFS : configuration"
	msg_checkFuseModule="Vérifiez que fuse est chargé."
	msg_checkFusePermission="Vérifiez si vous appartenez au groupe fuse. Dans une console, vous pouvez taper : \"sudo adduser $USER fuse\""
	msg_checkDestDir="Désolé, le répertoire de destination \"${destDir}\" existe déjà !"
	msg_mkDestDir="Le répertoire de destination \"${destDir}\" ne peut pas être créé."
	msg_askPassword_title="encFS : entrez votre phrase de passe ..."
	msg_askPassword_text="Entrez votre phrase de passe pour le répertoire \"${sourceDirName}\""
	msg_mount_abort="Opération annulée"
	msg_mountError="Le répertoire \"${destDir}\" ne peut pas être monté"
	msg_mount_finish="Répertoire \"${sourceDirName}\" monté dans \"${destDir}\""
	msg_umount_finish="Répertoire \"${destDir}\" démonté et supprimé"
	msg_preCreate="Le répertoire semble non chiffré, voulez-vous continuer?"
	msg_preCreate_cancel="La création du répertoire chiffré a été annulée."
	msg_change_password_error="Problème lors du changement de mot de passe de \"${sourceDirName}\"!\nCe n'est pas un répertoire chiffré avec encFS."
	msg_change_password_konsole_title="Changer le mot de passe \"${sourceDirName}\""
	msg_get_information_title="Informations de \"${sourceDirName}\""
	msg_get_informations_problem="Problème lors de la récupération des informations de \"${sourceDirName}\""
	msg_config_cryptMode="Mode Crypt préféré : "
	msg_config_cryptMode_standard="Standard, sécurisé et compatible."
	msg_config_cryptMode_paranoia="Paranoïa, plus sûr mais moins compatible."
	msg_config_autoUnmount="Démonter automatiquement le répertoire ?"
	msg_config_autoUnmount_fm="Oui, après la fermeture du gestionnaire de fichiers."
	msg_config_autoUnmount_no="Non, je le ferai manuellement."
	msg_config_saved="Paramètres enregistrés."
	msg_save_config_failed="Réglages non enregistrés !"
}

load_language_it () {
	msg_error_title="Errore encfs!"
	msg_warning_title="Avviso encFS!"
	msg_info_title="Informazione encFS"
	msg_config_title="encFS: configurazione"
	msg_checkFuseModule="Controllare che il modulo fuse sia caricato"
	msg_checkFusePermission="Controllare di appartenere al gruppo fuse. Dal terminale puoi digitare: \"sudo adduser $USER fuse\""
	msg_checkDestDir="Spiacente, la directory di destinazione \"${destDir}\" esiste già!."
	msg_mkDestDir="Non è possibile creare la directory di destinazione \"${destDir}\"."
	msg_askPassword_title="encFS: inserisci password ..."
	msg_askPassword_text="Digita la password per \"${sourceDirName}\":"
	msg_mount_abort="Operazione annullata"
	msg_mount_finish="Directory \"${sourceDirName}\" montata in \"${destDir}\""
	msg_mountError="Si è verificato un errore durante il montaggio della directory \"${destDir}\""
	msg_umount_finish="Directory \"${destDir}\" smontata e rimossa."
	msg_preCreate="Sembra che la cartella non sia cifrata, vuoi cifrarla?"
	msg_preCreate_cancel="La cifratura della cartella \"${sourceDirName}\" è stata annullata."
	msg_change_password_error="Problemi cambiando la password di \"${sourceDirName}\"!\nLa directory non sembra essere cifrata con encFS."
	msg_change_password_konsole_title="Cambio password di \"${sourceDirName}\""
	msg_get_information_title="Informazioni su \"${sourceDirName}\""
	msg_get_informations_problem="Problema nel caricamento delle informazioni.\nAssicurati che \"${sourceDirName}\" sia una directory cifrata con encfs."
	msg_config_cryptMode="Modo di cifratura preferito:"
	msg_config_cryptMode_standard="Predefinito, sicuro e compatibile"
	msg_config_cryptMode_paranoia="Paranoia, più sicuro ma meno compatibile."
	msg_config_autoUnmount="Smonta automaticamente la cartella?"
	msg_config_autoUnmount_fm="Si, non appena il file manager viene chiuso."
	msg_config_autoUnmount_no="No, lo faccio io manualmente."
	msg_config_saved="Impostazioni salvate."
	msg_save_config_failed="Impossibile salvare le impostazioni!"
}

load_language_ru () {
	msg_error_title="Ошибка encFS"
	msg_warning_title="Внимание encFS"
	msg_info_title="Информация encFS"
	msg_config_title="encFS: конфигурация"
	msg_checkFuseModule="Проверьте, загружен ли модуль fuse"
	msg_checkFusePermission="Проверьте: вы должны быть в группе fuse. Наберите в консоле: \"sudo adduser $USER fuse\""
	msg_checkDestDir="Целевая директория \"${destDir}\" уже существует!"
	msg_mkDestDir="Невозможно создать целевую директорию \"${destDir}\""
	msg_askPassword_title="encFS: введите пароль ..."
	msg_askPassword_text="Введите пароль для \"${sourceDirName}\":"
	msg_mount_abort="Операция отменена"
	msg_mountError="Невозможно монтировать целевую директорию \"${destDir}\""
	msg_mount_finish="Директория \"${sourceDirName}\" смонтирована в \"${destDir}\""
	msg_umount_finish="Директория \"${destDir}\" размонтирована и удалена"
	msg_preCreate="Директория не зашифрована, продолжить?"
	msg_preCreate_cancel="Создание зашифрованной директории отменено."
	msg_change_password_error="Есть проблемы, изменение пароля \"${sourceDirName}\"!\nЭто не EncFS зашифрованных каталогов."
	msg_change_password_konsole_title="Изменение пароля для \"${sourceDirName}\""
	msg_get_information_title="Информация о \"${sourceDirName}\""
	msg_get_informations_problem="Проблема при получении информации о \"${sourceDirName}\"."
	msg_config_cryptMode="Шифрование режим предпочтителен:"
	msg_config_cryptMode_standard="Стандартный, безопасной и совместимой."
	msg_config_cryptMode_paranoia="Паранойя, более безопасный, но менее совместимыми."
	msg_config_autoUnmount="Автоматически размонтировать каталог?"
	msg_config_autoUnmount_fm="Да, после закрытого файловый менеджер."
	msg_config_autoUnmount_no="Нет, я делаю это вручную."
	msg_config_saved="Настройки сохранены."
	msg_save_config_failed="Настройки не сохраняются!"
}

################################################

checkFuse () {
	[ -c /dev/fuse ] || { "${KDIALOG}" --title "${msg_error_title}" --caption "${msg_error_title}" --icon dialog-cancel --sorry "${msg_checkFuseModule}"; exit; }
	[ -r /dev/fuse ] && [ -w /dev/fuse ] || { "${KDIALOG}" --title "${msg_error_title}" --caption "${msg_error_title}" --icon dialog-cancel --sorry "${msg_checkFusePermission}"; exit; }
}

# this function is used when this call itself recursively for print password (encfs --extpass option, want argument an extern program)
# warning: do not print other information from script otherwise break decrypt of source directory because output is not only and clean password!!!
askPassword () {
	echo "${2}"
}

encMount () {
	PASSWORD=$("${KDIALOG}" --title "${msg_askPassword_title}" --caption "${msg_askPassword_title}" --password "${msg_askPassword_text}") || {
		"${KDIALOG}" --title "${msg_warning_title}" --passivepopup "${msg_mount_abort}" 5
		exit
		}

	# Check destination directory
	[ -d "${destDir}" ] && { "${KDIALOG}" --title "${msg_error_title}" --caption "${msg_error_title}" --icon dialog-cancel --sorry "${msg_checkDestDir}"; exit; }

	# Make destination directory
	mkdir "${destDir}" || { "${KDIALOG}" --title "${msg_error_title}" --caption "${msg_error_title}" --icon dialog-cancel --error "${msg_mkDestDir}"; exit; }

	# var $cryptMode: encfs use only first letter of $cryptMode but I used long names for more readability.
	echo "${cryptMode}" | encfs --extpass="$0 ${lang} askPassword ${sourceDir} '${PASSWORD}'" "${sourceDir}" "${destDir}" || {
		"${KDIALOG}" --title "${msg_error_title}" --caption "${msg_error_title}" --icon dialog-cancel --error "${msg_mountError}"
		rm -r "${destDir}"
		exit
		}
	"${KDIALOG}" --title "${msg_info_title}" --passivepopup "${msg_mount_finish}" 5
	"${FILEMANAGER}" "${destDir}"
	[ "x${autoUnmount}" = "xfm" ] && encMountUmountCreate "${sourceDir}"
	exit
}

encMountUmountCreate () {
	# To remember: In the /proc/mounts, there is the name of the destination directory.
	# if the directory is mounted (In this case, you've clicked on the destination directory)
	if [ -n "$(grep "encfs ${sourceDir} fuse.encfs" /proc/mounts)" ]
		# then unmount it.
		then fusermount -u "${sourceDir}" && rm -r "${sourceDir}" && "${KDIALOG}" --title "${msg_info_title}" --passivepopup "${msg_umount_finish}" 5
		# else, if the directory is mounted (In this case, you've clicked on the source directory)
		else if [ -n "$(grep "encfs ${destDir} fuse.encfs" /proc/mounts)" ]
				# then unmount it.
				then fusermount -u "${destDir}" && rm -r "${destDir}" && "${KDIALOG}" --title "${msg_info_title}" --passivepopup "${msg_umount_finish}" 5
				# else mount or encrypt it.
				else encfsctl info "${sourceDir}" > /dev/null && encMount "${@}" || {
					"${KDIALOG}" --title "${msg_warning_title}" --caption "${msg_warning_title}" --icon preferences-desktop-cryptography --warningyesno "${msg_preCreate}" && \
					encMount "${@}" || \
					"${KDIALOG}" --title "${msg_info_title}" --passivepopup "${msg_preCreate_cancel}" 5
					}
			fi
	fi
}

encPasswdChange () {
	encfsctl info "${sourceDir}" > /dev/null && \
	konsole --title "${msg_change_password_konsole_title}" --caption "${msg_change_password_konsole_title}" --icon dialog-password -e encfsctl passwd "${sourceDir}" || \
	"${KDIALOG}" --title "${msg_error_title}" --caption "${msg_error_title}" --icon error --error "${msg_change_password_error}"
}

encDirInfo () {
	infoMsg=`encfsctl info "${sourceDir}"` || infoMsg="${msg_get_informations_problem}"
	"${KDIALOG}" --title "${msg_get_information_title}" --caption "${msg_get_information_title}" --icon help-about --msgbox "${infoMsg}"
}

readConfig () {
	if [ -f "${CONFIGFILE}" ]
		then
			cryptMode=$(grep -i "cryptMode" "${CONFIGFILE}" | sed "s/.*= *//")
			autoUnmount=$(grep -i "AutoUnmount" "${CONFIGFILE}" | sed "s/.*= *//")
		else # load standard values
			cryptMode="standard"
			autoUnmount="fm"
	fi
}

askConfig () {
	cryptMode=$("${KDIALOG}" --title "${msg_config_title} 1/2" --caption "${msg_config_title} 1/2" --icon configure --radiolist "${msg_config_cryptMode}" "standard" "${msg_config_cryptMode_standard}" $([ "x${cryptMode}" = "xstandard" ] && echo "on" || echo "off") "paranoia" "${msg_config_cryptMode_paranoia}" $([ "x${cryptMode}" = "xparanoia" ] && echo "on" || echo "off")) || exit
	autoUnmount=$("${KDIALOG}" --title "${msg_config_title} 2/2" --caption "${msg_config_title} 2/2" --icon configure --radiolist "${msg_config_autoUnmount}" "fm" "${msg_config_autoUnmount_fm}" $([ "x${autoUnmount}" = "xfm" ] && echo "on" || echo "off") "no" "${msg_config_autoUnmount_no}" $([ "x${autoUnmount}" = "xno" ] && echo "on" || echo "off")) || exit
}

writeConfig () {
	[ -d "${CONFIGDIR}" ] || mkdir -p "${CONFIGDIR}"
	:> "${CONFIGFILE}" && \
	echo "CryptMode=${cryptMode}" >> "${CONFIGFILE}" && \
	echo "AutoUnmount=${autoUnmount}" >> "${CONFIGFILE}" && \
	"${KDIALOG}" --title "${msg_info_title}" --passivepopup "${msg_config_saved}" 5 || \
	"${KDIALOG}" --title "${msg_error_title}" --caption "${msg_error_title}" --icon error --msgbox "${msg_save_config_failed}"
}

encConfigure () {
	askConfig
	writeConfig
}

################################################ main

"load_language_${lang}" || load_language_en

checkFuse
readConfig
"${action}" "${@}"
