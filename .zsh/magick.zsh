merge_images() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: output.png input1.png input2.png [input3.png ...]"
    return 1
  fi

  output="merge_$(date +%s).png"

  magick montage "$@" -tile "${#@}x1" -geometry +0+0 "$output"

  echo "Output file: ${output}"
}
