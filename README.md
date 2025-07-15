there is just the one script\
run it with `swift comboCalc.swift`


this uses `cocoa`, if anybody cares.

> [!NOTE]
> don't put very large numbers in. these sorts of calculations get REALLY BIG, REALLY QUICKLY, and this thing isn't designed for beefy maths - although if you want to change that, knock yourself (and your computer) out!!! and then come commit the changes for everyone else :)\
> id say about `20` is max, but feel free to test it - the worst that will happen is the script crashing.

## Explanation:
(this is also written in the script)

### (quick variable definition):
  - **`y`** = characters
  - **`x`** = spaces
  - **`z`, `w`**, etc. = factors of `x`; rotation, for example. A combination of combinations!
  - **`C(x,y)`** = representative of the combinations between characters and spaces, with repeats unspecified.


### The actual formulas:

  - If `x` **can be repeated**: **`x^y`**
    - Each number can be used more than once in the combination - say if y=3, then `225`, `363` are all possible.



  - If `x` **cannot repeat**: `x!/(x-y)!`



  - Say `x` is a combination itself - multi factor combination: C(x,y) * C(z,y) * C(w,y) - and so on for each value under `x`
    - See `z` & `w` above - We're now calculating a combination of combinations: Let's arrange 5 squares - thats `x`. As well as combination of `x`, each of `x` - those squares - could also be rotated up to 4 times - `z`! And maybe the squares can't repeat but the same rotation can appear multiple times...\
So `x` in itself could be a combination! MAYBE EVEN A COMBINATION OF COMBINATIONS!!



### im finished now

**if you actually want to get a good understanding of this, go read the functions section of the script. lots of good stuff there.**

i hope you understand what I mean
see the `about` panel for info: Menu bar > swift-frontend > About Script

the `Spaces` input is equivalent to `y` above
same with `Inputs` = `x`
`Factor 1` & `Factor 2` = `z` & `w`

There you go.

> [!NOTE]
> ChatGPT helped a little bit.\
> Though, only a little, mind! I did actually do a lot of it!!!
> Aaand, I actually took in and tried to understand what was happening.\
> Happy? OK, fine, keep saying I got the AI to do it... Some people, you'll just never get through to...
