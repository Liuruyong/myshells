# 删除Mac下默认英文键位(U.S.) ,删除完可以把Programmer Dvorak键位设置为默认键位
for file in ~/Library/Preferences/com.apple.HIToolbox.plist; do 
	for key in AppleCurrentKeyboardLayoutInputSourceID; do 
		/usr/libexec/PlistBuddy -c "delete :${key}" ${file} 
		/usr/libexec/PlistBuddy -c "add :${key} string 'com.apple.keylayout.Programmer Dvorak'" ${file} 
	done 
	for key in AppleDefaultAsciiInputSource AppleCurrentAsciiInputSource AppleCurrentInputSource AppleEnabledInputSources AppleInputSourceHistory AppleSelectedInputSources; do 
		/usr/libexec/PlistBuddy -c "delete :${key}" ${file} 
		/usr/libexec/PlistBuddy -c "add :${key} array" ${file} 
		/usr/libexec/PlistBuddy -c "add :${key}:0 dict" ${file} 
		/usr/libexec/PlistBuddy -c "add :${key}:0:InputSourceKind string 'Keyboard Layout'" ${file} 	
		/usr/libexec/PlistBuddy -c "add ':${key}:0:KeyboardLayout ID' integer 6454" ${file} 
		/usr/libexec/PlistBuddy -c "add ':${key}:0:KeyboardLayout Name' string 'Programmer Dvorak'" ${file} 
	done 
done
