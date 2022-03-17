### Procedure for automatic text normalization(ATN) (TTS context)

<!-- - Input a `txt` file with sentences to be normalized by -->
  <!-- - `xlsx file`
<!-- - Run script `x` that converts the `xlsx` file in a `txt` file -->
- First time:
  - 0 Clone the <repo>
  - 0.1 move to the `TN_w_IRISA`dir
- Post-first time:
  - 1 paste all the raw-text-sentences that need to be automatically normalized in `ATN_input.txt`
  - 2 Paste the Manually normalized sentences in `goldStandard_tts.txt`
    - (TODO 'specify a xlsx file, with ATN sentences in the A column, and Golden standard sentences in the B column')
  - 3 in your terminal, run: `bash e2e_normalization.sh`
    - The normalized sentences are located in `output.5tts.txt`
  - 4 In your terminal, run: `python3 txt-to-df.py`
    - `levenhstein_distance_input.xlsx` will be outputted; column A==`output.5tts.txt` , column B==`goldStandard_tts`

### For evaluating the ATN:
<!-- - Input `output.5tts.txt` & `goldStandard_tts.txt` -->
- 5 In your terminal, run: `python3 Levenhstein_distance.py`
  - input the
- 6 Observe the edit-distance per text between the ATN & MTN in the file: `levenhstein_distance_output.xlsx`

- Alternatively, run all commands:
`bash e2e_normalization.sh; python3 txt-to-df.py levenhstein_distance_input.xlsx`

## TODO

### Need-to-haves
- Create a shell script to automize steps 1-6 (after having made the adjustments during working for ticket tlz-83)
- Flagging the encoding errors that are in `output.5tts.txt` automatically.

### Nice to haves:
- post- step 6
  - Integration  with a 'diff' program--such as sublime merge--; where, whenever the edit-distance of a sentence surpasses a defined threshold, that sentence is automatically inputted in that diff program, and the manual ATN-double-checker can observe the differences between the 2 sentences visually. (Now the process of getting it in the diff-program is still manual)
[sublime-merge-diff-program-preview](https://ibb.co/b3YbnFB)
