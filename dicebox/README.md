This is a remix of [OpenSCAD dice box by Xavier Faraudo](https://www.printables.com/model/440186-openscad-dice-box) with changes to fit some [dice I bought off of Aliexpress](https://www.aliexpress.us/item/3256806057500632.html).

The changes are mostly from measuring the dice and modifications suggested in the [comments of the design](https://www.printables.com/model/440186-openscad-dice-box/comments/1047670) (reproduced below).

![](7dice.jpeg)


## Comments

Well... this is "a bit complex" OpenSCAD project (understatement of the century), so first of all, don't judge OpenSCAD by this one, please. It can be a very gratifying thing.

Short answer: yes, they can. That will be a feature of version 2, which is currently in progress (and as of now, v2 allows each die to be rotated independently, so you can create nice patterns). But that will take "a while" (meaning weeks, if not months), as now I'm recovering from a data HDD crash and with other projects that I'll use for the v2 box.

Since I guess that you'll want it sooner than that, there's a patch you can do.
Go to line 1359, which is in the definition block for the d10, and it's a (part of) the statement that sets the rotation/orientation of the d10. Where it reads:

[0, 0, lay_on_flat ? -90 : -18], center = [0, 0, 0], zyx = true

change that -90 to the orientation that you see fit. I guess that -45 will do.

The full statement is, FWIW (and in case I didn't get the line number right):

d10 = rotate_polyseed(
rotate_polyseed( d10_raw, d10_rotation, center = [0, 0, 0], zyx = true ),
[0, 0, lay_on_flat ? -90 : -18], center = [0, 0, 0], zyx = true
);

It's the second set of parameters we're changing, and only when the die is laid on a face.

Another problem that you may find is that, actually, d10 can have several diameter-to-height ratios (allowing other ratios is a feature of v2, too). You can measure the equatorial diameter of two opposite points of the "belt" of the d10, and then its height from pole to pole. If the difference is of about a 5% or less, you'll be good as is (most d10 have some rounding, that induces errors in measurements). But if it's more or less than that, you should adjust its dimensions in line 1350. Where it says:

d10_raw = trapezohedron_seed( r = d10_r_ok, n = 5, h = 2 * d10_r_ok );

change the 2 multiplying d10_r_ok (the radius for the trapezohedron with clearance) by 2 * the height / diameter (as this 2 is a height to *radius* ratio, and diameter is 2 * radius).

Note that all dice definition blocks follow roughly the same structure, so you can rotate other dice, too. Just be careful to do it in the parameters of the *second* call of rotate_polyseed (the outermost, last one).

Yvendros
@Yvendros_489673
@XavierFaraudo Huh. Pretty sure you're a wizard. I didn't expect such a thorough, detailed, explanation.

I've changed the ratio to 2.5, and the rotation to -32. I'm queueing that up on the printer next to test it out.

Thanks for taking the time to explain all that, I would've also been content with waiting for v2. I'll check back in for that, and once my print is finished.

Much appreciated! (edited)

