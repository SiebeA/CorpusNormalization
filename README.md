
### Procedure for automatic text normalization(ATN) (TTS context)

<!-- - Salb this is how you can make A COMMENT that is not visible in the README outside the editor -->

- First time:
  - 0 Clone the `TN_w_IRISA` repo
- Post-first time:
  - `$ /TN_w_IRISA`
  - 1 paste all the raw-text-sentences that need to be automatically normalized in `ATN_input.txt`
  - 2 Paste the Manually normalized sentences in `goldStandard_tts.txt`
  - 3 in your terminal, run: `bash e2e_normalization.sh`
  <!-- TODO echo in the /e2e* that this might take a while, and the error messgaes that can be observed -->
    - The normalized sentences are located in `output.5tts.txt`
  - 4 In your terminal, run: `python3 txt-to-df.py`
    - `levenhstein_distance_input.xlsx` will be outputted; column A==`output.5tts.txt` , column B==`goldStandard_tts`

### For evaluating the ATN:
- 5 In your terminal, run: `python3 Levenhstein_distance.py`
- 6 Observe the edit-distance per text between the ATN & MTN in the file: `levenhstein_distance_output.xlsx`

- Alternatively, run all commands:
`bash e2e_normalization.sh; python3 txt-to-df.py levenhstein_distance

## TODO

### Need-to-haves
- Create a shell script to automize steps 1-6 (after having made the adjustments during working for ticket tlz-83)
- Flagging the encoding errors that are in `output.5tts.txt` automatically.
- if total lines between `ATN_input.txt` & `goldStandard_tts.txt`: print error
- ```bash
rm '" if it is the first symbol af a line, and there is no other one in the line'
```

### Nice to haves:
- post- step 6
  - Integration  with a 'diff' program--such as sublime merge--; where, whenever the edit-distance of a sentence surpasses a defined threshold, that sentence is automatically inputted in that diff program, and the manual ATN-double-checker can observe the differences between the 2 sentences visually. (Now the process of getting it in the diff-program is still manual)
[sublime-merge-diff-program-preview](https://ibb.co/b3YbnFB)


### observations made about the normalized text files
- Acronyms sa CD,DVD: "compact disc, digital video disc" are spelled out
- Line 1069 at `bessy*`, when copy and pasting it in sublime, they become seperate lines, plus quotationo mark is added.
