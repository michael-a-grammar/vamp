function Main {
    $target = Get-Item -Path ./.vimrc -Force | Select-Object -Expand FullName

    $path =
        if ($IsWindows) {
            "$env:LOCALAPPDATA/nvim/init.vim"
        } elseif ($IsMacOS) {
            "~/.config/nvim/init.vim"
        }

    New-Item -ItemType SymbolicLink -Target $target -Path $path
}

. Main

