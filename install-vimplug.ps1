function Main {
    $nvimAutoloadPath       = "$env:LOCALAPPDATA\nvim\autoload"
    $vimPlugFileName        = 'plug.vim'
    $vimPlugPath            = ".\vim-plug\$vimPlugFileName"
    $vimPlugDestinationPath = "$nvimAutoloadPath\$vimPlugFileName"

    if (-not (Test-Path -Path $nvimAutoloadPath)) {
        New-Item -ItemType Directory -Path $nvimAutoloadPath
    }

    if (-not (Test-Path -Path $vimPlugPath)) {

    }

    if (Test-Path $vimPlugDestinationPath) {

    }

    Copy-Item -Path $vimPlugPath -Destination $vimPlugDestinationPath
}

. Main

