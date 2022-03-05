#!/bin/bash

ROOT=/home/${USER}/dev/irisa-text-normalizer
LANGUAGE=en

# input=zsa_input.txt
input=examples/en/zsa_z_input.txt
output=zsa_output

# ASR_CFG=text.asr.txt
TTS_CFG=tts_siebe.cfg
NONE_CFG=siebe_none.cfg

echo -n "Starting process at: "; date; printf '\n'
echo "on input file:"; echo $input; printf '\n'

# General normalization
echo "Tokenization..."
perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > $output.tok

echo "Generic normalization start..."
perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl $output.tok > $output.start

echo "Currency conversion..."
perl $HOME/dev/tl_lm_resources/normalizers/irisa_normalizer/convert_currencies.pl $output.start > $output.currency_fix.txt

echo "Generic normalization end..."
perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl $output.currency_fix.txt > $output.general_norm.txt

Specific
echo "ASR specific normalization..., with the cfg file:"
echo $ASR_CFG
echo " "
perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$ASR_CFG $output.general_norm.txt > $output.asr.txt

echo "TTS specific normalization..."
perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG $output.general_norm.txt > $output.tts.txt

# # sa try to source from earlier output:
# echo "TTS specific normalization..."
# perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG $output.start > $output.tts.txt


# Remove some punctuation:
# sed -i "s/\./ /g" $output.asr.txt
# sed -i "s/,/ /g" $output.asr.txt
# sed -i 's/ \+ / /g' $output.asr.txt

# sed -i "s/\./ /g" $output.tts.txt
# sed -i "s/,/ /g" $output.tts.txt
# sed -i 's/ \+ / /g' $output.tts.txt
# Remove empty lines in ASR and TTS:
echo "Removing empty lines..."
sed -i '/^\s*$/d' $output.asr.txt
sed -i '/^\s*$/d' $output.tts.txt

# Finished
echo -n "Done. Finished at: "; date; printf '\n'
echo $(date)
