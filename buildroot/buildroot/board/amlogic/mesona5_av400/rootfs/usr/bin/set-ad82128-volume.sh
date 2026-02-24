#!/bin/sh
val=$1
amixer cset name='ad82128_c_30 Ch1 Volume' $val
amixer cset name='ad82128_c_30 Ch2 Volume' $val
amixer cset name='ad82128_c_31 Ch1 Volume' $val
amixer cset name='ad82128_c_31 Ch2 Volume' $val
amixer cset name='ad82128_c_34 Ch1 Volume' $val
amixer cset name='ad82128_c_34 Ch2 Volume' $val
amixer cset name='ad82128_c_35 Ch1 Volume' $val
amixer cset name='ad82128_c_35 Ch2 Volume' $val

amixer cset name='ad82128_d_30 Ch1 Volume' $val
amixer cset name='ad82128_d_30 Ch2 Volume' $val
amixer cset name='ad82128_d_31 Ch1 Volume' $val
amixer cset name='ad82128_d_31 Ch2 Volume' $val
amixer cset name='ad82128_d_34 Ch1 Volume' $val
amixer cset name='ad82128_d_34 Ch2 Volume' $val
amixer cset name='ad82128_d_35 Ch1 Volume' $val
amixer cset name='ad82128_d_35 Ch2 Volume' $val