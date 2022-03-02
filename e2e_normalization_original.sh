#!/bin/bash

ROOT=/home/${USER}/dev/irisa-text-normalizer
LANGUAGE=en

input=examples/en/text.raw.txt
output=output

TTS=tts_siebe.cfg
ASR=asr_siebe.cfg

echo -n "Starting process at: "; date

# General normalization
echo "Tokenization..."
perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > $output.tok
echo "Generic normalization start..."
perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl $output.tok > $output.start
echo "Currency conversion..."
perl $HOME/dev/tl_lm_resources/normalizers/irisa_normalizer/convert_currencies.pl $output.start > $output.currency_fix.txt
echo "Generic normalization end..."
perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl $output.currency_fix.txt > $output.general_norm.txt

# Specific
echo "ASR specific normalization..."
perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$ASR $output.general_norm.txt > $output.asr.txt
echo "TTS specific normalization..."
perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS $output.general_norm.txt > $output.tts.txt

# Remove some punctuation:
sed -i "s/\./ /g" $output.asr.txt
sed -i "s/,/ /g" $output.asr.txt
sed -i 's/ \+ / /g' $output.asr.txt

sed -i "s/\./ /g" $output.tts.txt
sed -i "s/,/ /g" $output.tts.txt
sed -i 's/ \+ / /g' $output.tts.txt
# Remove empty lines in ASR and TTS:
echo "Removing empty lines..."
sed -i '/^\s*$/d' $output.asr.txt
sed -i '/^\s*$/d' $output.tts.txt

# Finished
echo -n "Done. Finished at: "; date