# RISC-V Assembling

I've wanted to understand computers on a lower level for a while now, but the enormous
complexity of the older x86 and ARM instruction sets have made the topic rather
intimidating to approach. With more powerful RISC-V hardware slowly becoming available
I felt like this was a good time to jump on the hype train, so I bought a StarFive
VisionFive 2 single-board RISC-V computer. This repository is for documenting my journey
of learning how to use it and specifically the RISC-V assembly language. I'm publishing
it because I thought some of my notes could be useful to someone else going through the
same process (it seems there's not very much beginner-friendly RISC-V material
available yet), and I'm too lazy to make a blog. Maybe I will edit this content down
into a more concise tutorial format eventually (if I ever learn enough to feel like I
actually know what I'm doing), but for now it's more of a learning diary.


## Why RISC-V?

RISC-V is a new, modular, open standard instruction set architecture. I like new things, I like modular things, and I like open standards. I think I will like RISC-V.

Talks about RISC-V on YouTube:
* [RISC-V is the future of computing](https://www.youtube.com/watch?v=lXdx0X2WHfY) (Chris Lattner on the Lex Fridman podcast)
* [The Golden Age of Compiler Design in an Era of HW/SW Co-design](https://www.youtube.com/watch?v=4HgShra-KnY) by Chris Lattner
* [The Genius of RISC-V Microprocessors](https://www.youtube.com/watch?v=L9jvLsvkmdM) by Erik Engheim


## Mistakes and errors

Although I have what I would consider a pretty solid programming background from higher
level languages, and a number of years of experience with Linux, I'm completely new to
writing code at such a low level. This means there will likely be some mistakes and
errors. Please don't hesitate to point out any and all such issues if you notice them
(however small and inconsequential they may be). To report an error, open an issue in
this repository.
