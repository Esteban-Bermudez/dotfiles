```
  __  _      ___      ______   ______   .__   __.  _______  __    _______ 
 /  \/ |    /  /     /      | /  __  \  |  \ |  | |   ____||  |  /  _____|
|_/\__/    /  /     |  ,----'|  |  |  | |   \|  | |  |__   |  | |  |  __  
          /  /      |  |     |  |  |  | |  . `  | |   __|  |  | |  | |_ | 
         /  /    __ |  `----.|  `--'  | |  |\   | |  |     |  | |  |__| | 
        /__/    (__) \______| \______/  |__| \__| |__|     |__|  \______| 

```

## 🚀 How to Set Up

### One-Liner Install

```bash
curl -fsSL https://raw.githubusercontent.com/Esteban-Bermudez/dotfiles/main/install.sh | sh
```

### Manual Installation

Follow these steps to clone this repository and set up your environment:

#### 1. Clone the Repository

##### Clone the repo with submodules into ~/.config
```bash
git clone --recurse-submodules https://github.com/Esteban-Bermudez/dotfiles.git ~/.config
```

#### 2. Create the .zshenv File

Add a .zshenv file in your home directory with the following content:

##### Point Zsh to the custom configuration directory
```bash
ZDOTDIR=~/.config/zsh/
```

##### Command to create the file automatically:
```bash
echo 'ZDOTDIR=~/.config/zsh/' > ~/.zshenv
```

#### 3. Reload Zsh

Start a new Zsh session or reload your shell with:

```bash
source ~/.zshenv
```
