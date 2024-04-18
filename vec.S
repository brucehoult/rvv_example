    # void vec_len_rvv(float *r, struct pt *pts, int n)

    #define r a0
    #define pts a1
    #define n a2
    #define vl a3
    #define Xs v0
    #define Ys v1
    #define Zs v2
    #define lens v3
    
    .globl vec_len_rvv
vec_len_rvv:
    # 32 bit elements, don't care (Agnostic) how tail and mask are handled
    vsetvli vl, n, e32, ta,ma
    vlseg3e32.v Xs, (pts) # loads interleaved Xs, Ys, Zs into 3 registers
    vfmul.vv lens, Xs, Xs
    vfmacc.vv lens, Ys, Ys
    vfmacc.vv lens, Zs, Zs
    vfsqrt.v lens, lens
    vse32.v lens, (r)
    sub n, n, vl
    sh2add r, vl, r # bump r ptr 4 bytes per float
    sh1add vl, vl, vl # multiply vl by 3 floats per point
    sh2add pts, vl, pts # bump v ptr 4 bytes per float (12 per pt)
    bnez n, vec_len_rvv
    ret
