function Main {
    Start-Process -Path nvim -ArgumentList '-c PlugInstall', '-c qa!'
}

. Main

