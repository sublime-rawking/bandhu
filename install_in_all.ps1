echo "Buidling apk now ...."
flutter build apk 
echo "Build completed"
$adbDevices = adb devices | Select-Object -Skip 1 | ForEach-Object { $_.Split("`t")[0] }
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
echo "Connected Devices"
foreach ($device in $adbDevices) {
    if($device -eq "") {
        continue 
    }
    $deviceName = adb -s $device shell getprop ro.product.model
    echo  $deviceName 
    
}
foreach ($device in $adbDevices) {
    if($device -eq "") {
        continue 
    }
    $deviceName = adb -s $device shell getprop ro.product.model
    echo "installing on $deviceName now"
    adb -s $device install $apkPath
    adb -s $device shell am start -n com.example.bandhu/com.example.bandhu.MainActivity
}


# $filePath = "build\app\outputs\flutter-apk\app-release.apk"
# $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
# $newFilePath = "build\app\outputs\flutter-apk\Featherr-$timestamp.apk"

# Rename-Item -Path $filePath -NewName $newFilePath
# Rename-Item : Cannot rename the specified target, because it represents a path or device name.