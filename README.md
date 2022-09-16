# cowriter.vim

Like [copilot.vim](https://github.com/github/copilot.vim) or [openai.vim](https://github.com/jessfraz/openai.vim), this is a vim plugin for calling [OpenAI's GPT-3 API](https://openai.com/blog/openai-api/) for text completion. To do so, we use `curl`, `jq`, and the `OPENAI_API_KEY` you've (hopefully) got set in your environment.

> **NOTE**: This is a half-finished experiment, baby's first vim plugin, and only intended to be a convenience wrapper for unstructured text generation (ie, in markdown files). You probably do not want to use this. Look elsewhere.

You bring your own API key. You use at your own risk.

## Installation

1. Make sure you have `curl` and `jq` installed.
2. Set `OPENAI_API_KEY` in your environment.
3. Use one of
    - [Vundle](https://github.com/VundleVim/Vundle.vim)
        - `Plugin 'gcuth/cowriter.vim'`
    - [vim-plug](https://github.com/junegunn/vim-plug)
        - `Plug 'gcuth/cowriter.vim'`
    - [Pathogen](https://github.com/tpope/vim-pathogen)
        - `git clone https://github.com/gcuth/cowriter.vim.git ~/.vim/bundle/cowriter.vim`

## Usage

Map `:call CoWrite()` to something convenient in your `.vimrc`, such as

```
nnoremap <leader>c :call CoWrite()<CR>
```
