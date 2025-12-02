
help:
    @just --list

new-day daynum:
    gleam new --skip-github --name advent day_{{daynum}}
