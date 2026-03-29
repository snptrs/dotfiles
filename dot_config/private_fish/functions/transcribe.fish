function transcribe --description "Transcribe audio/video using whisper.cpp"

    # ── config ────────────────────────────────────────────────────────────────
    # Override these permanently by running:
    #   set -Ux WHISPER_CLI /path/to/whisper-cli
    #   set -Ux WHISPER_MODELS_DIR /path/to/models/
    set -q WHISPER_CLI; or set WHISPER_CLI ~/Code/Repos/whisper.cpp/build/bin/whisper-cli
    set -q WHISPER_MODELS_DIR; or set WHISPER_MODELS_DIR ~/Code/Repos/whisper.cpp/models

    # ── validate ──────────────────────────────────────────────────────────────
    if test (count $argv) -eq 0
        echo "Usage: transcribe <file>"
        return 1
    end

    if not test -f $argv[1]
        echo "Error: file not found: $argv[1]"
        return 1
    end

    if not command -q ffmpeg
        echo "Error: ffmpeg is not installed (brew install ffmpeg)"
        return 1
    end

    if not test -x $WHISPER_CLI
        echo "Error: whisper-cli not found at $WHISPER_CLI"
        echo "Set the correct path with: set -Ux WHISPER_CLI /path/to/whisper-cli"
        return 1
    end

    set input (realpath $argv[1])
    set stem (path change-extension "" (path basename $input))
    set outdir (path dirname $input)

    # ── model selection ───────────────────────────────────────────────────────
    set models (path sort -- $WHISPER_MODELS_DIR/ggml-*.bin)

    if test (count $models) -eq 0
        echo "Error: no models found in $WHISPER_MODELS_DIR"
        echo "Set the correct path with: set -Ux WHISPER_MODELS_DIR /path/to/models"
        return 1
    end

    echo ""
    echo "Model:"
    set i 1
    for m in $models
        echo "  $i) "(path basename $m)
        set i (math $i + 1)
    end

    read -P "  → " modelchoice
    echo ""

    if test -z "$modelchoice" -o "$modelchoice" = 1
        set chosenmodel $models[1]
    else if test $modelchoice -ge 1 -a $modelchoice -le (count $models)
        set chosenmodel $models[$modelchoice]
    else
        echo "Error: invalid choice"
        return 1
    end

    # ── convert to 16-bit mono WAV ────────────────────────────────────────────
    set tmpwav /tmp/whisper_(random).wav
    echo "⏳ Preparing audio..."
    if not ffmpeg -i $input -ar 16000 -ac 1 -c:a pcm_s16le $tmpwav -y -loglevel quiet
        echo "Error: ffmpeg failed to convert the file"
        rm -f $tmpwav
        return 1
    end

    # ── prompts ───────────────────────────────────────────────────────────────
    echo "Output format:"
    echo "  1) txt  (default)"
    echo "  2) vtt"
    echo "  3) srt"
    echo "  4) json"
    echo "  5) all of the above"
    read -P "  → " fmt
    echo ""

    switch $fmt
        case 2
            set fmtflags --output-vtt
            set fmtname vtt
        case 3
            set fmtflags --output-srt
            set fmtname srt
        case 4
            set fmtflags --output-json
            set fmtname json
        case 5
            set fmtflags --output-txt --output-vtt --output-srt --output-json
            set fmtname "txt, vtt, srt, json"
        case "*"
            set fmtflags --output-txt
            set fmtname txt
    end

    read -P "Language code (e.g. en, fr, de — leave blank to auto-detect): " lang
    echo ""
    set langflag
    if test -n "$lang"
        set langflag -l $lang
    end

    read -P "Translate output to English? [y/N]: " totranslate
    echo ""
    set translateflag
    if string match -qi y $totranslate
        set translateflag --translate
    end

    # ── transcribe ────────────────────────────────────────────────────────────
    echo "🎙  Transcribing $stem..."
    echo "    Model    : "(path basename $chosenmodel)
    echo "    Format   : $fmtname"
    if test -n "$lang"
        echo "    Language : $lang"
    else
        echo "    Language : auto-detect"
    end
    if test -n "$translateflag"
        echo "    Translate: yes"
    end
    echo "    Output   : $outdir/"
    echo ""

    $WHISPER_CLI \
        -m $chosenmodel \
        -f $tmpwav \
        $langflag \
        $translateflag \
        $fmtflags \
        --output-file $outdir/$stem

    set result $status
    rm -f $tmpwav

    if test $result -eq 0
        echo ""
        echo "✅ Done! Saved to $outdir/$stem.[$fmtname]"
    else
        echo ""
        echo "❌ whisper-cli exited with an error"
        return 1
    end

end
