" Track plugin autoload
if exists('g:autoloaded_cowriter')
    finish
endif
let g:autoloaded_cowriter = 1

function! cowriter#Request(text)
    " Take a chunk of text as a prompt and send it to the openai gpt3 api
    " to get a response
    let openai_api_key = $OPENAI_API_KEY " api key from environment
    let openai_api_url = 'https://api.openai.com/v1/completions' " api url
    let model = 'text-davinci-002' " the model to use (current best)
    let max_tokens = 100 " max number of tokens to return
    let temperature = 0.9 " temperature of the model

    " build a request dictionary out of these key variables (& text prompt)
    let request = {
                \ 'model': model,
                \ 'max_tokens': max_tokens,
                \ 'temperature': temperature,
                \ 'n': 1,
                \ 'prompt': substitute(trim(a:text), '"' , '\\"', 'g'),
                \ }

    " turn the request dictionary into a json string
    let request_json = json_encode(request)

    " save the prompt/request json to a temporary file
    let request_file = tempname()
    call writefile([request_json], request_file)

    " a curl command to send the request to the api & use jq to process it
    let command = "curl -sSL " . openai_api_url . " -H 'Content-Type: application/json' -H 'Authorization: Bearer " . openai_api_key . "' -d @" . request_file . " | jq -r '.choices[0].text'"

    " actually make the request
    let response = trim(system(command))

    return response

endfunction

function! CoWrite()
    " Get the current file up to the cursor and send (as a prompt) to the
    " openai gpt3 api to get a completion. Then insert the completion.
    
    let end_line = getpos(".")[1] " get current line position of the cursor
    let end_column = getpos(".")[2] " get current column position of the cursor
    let lines = getline(0, end_line) " all the lines up to the cursor line
    
    let clean_lines = [] " a list for collecting cleaned lines
    for line in lines " loop over all the lines, 'clean' them, then add to list
        let clean_lines += [substitute(trim(line), '\n', '', 'g')]
    endfor

    let text = join(clean_lines, "\\n") " create a single text object of lines
	
    " use the text to request a completion from the openai gpt3 api
    let completion = cowriter#Request(text)

    " get each line in the completion
    let completion_lines = split(substitute(substitute(completion, '\\n', '\n', 'g'), '\\"', '\"', 'g'), "\n")

    " if the end_column position is not 0, then we need to append the first
    " completion line to the *end* of the current line (rather than new line)
    if end_column != 0
        let current_line = getline(end_line)
        let new_current_line = trim(current_line) . " " . trim(completion_lines[0])
        call setline(end_line, new_current_line)
        let completion_lines = completion_lines[1:]
    endif
    
    " append completion lines, starting at current cursor/line position
    for line in completion_lines
        call append(end_line, substitute(substitute(trim(line), '\n', '', 'g'), '\\n', '', 'g'))
        let end_line += 1
    endfor

endfunction


