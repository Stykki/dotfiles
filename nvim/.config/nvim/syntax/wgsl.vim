" Vim syntax file for WGSL (WebGPU Shading Language)
" Used when no tree-sitter parser is available.

if exists("b:current_syntax")
    finish
endif

syn case match

" Comments
syn keyword wgslTodo contained TODO FIXME XXX NOTE SAFETY
syn region wgslComment start="//" skip="\\$" end="$" contains=wgslTodo,@Spell keepend
syn region wgslComment start="/\*" end="\*/" contains=wgslComment,wgslTodo,@Spell fold extend

" Preprocessor-style directives used by engines (Bevy, wgsl-preprocessor, ...)
syn match wgslPreProc "^\s*#\s*\%(import\|define_import_path\|define\|ifdef\|ifndef\|if\|else\|endif\|export\)\>.*$" contains=wgslComment

" Directives
syn keyword wgslDirective enable requires diagnostic

" Keywords
syn keyword wgslKeyword alias break case const const_assert continue continuing
syn keyword wgslKeyword default discard else fn for if let loop override return
syn keyword wgslKeyword struct switch var while
syn keyword wgslBoolean true false

" Address spaces / access modes / interpolation
syn keyword wgslStorageClass function private workgroup uniform storage
syn keyword wgslStorageClass read write read_write
syn keyword wgslStorageClass perspective linear flat center centroid sample
syn keyword wgslStorageClass first vertex either

" Scalar & vector & matrix types
syn keyword wgslType bool f16 f32 i32 u32
syn match wgslType "\<vec[234]\%[hfiu]\>"
syn match wgslType "\<mat[234]x[234]\%[hf]\>"
syn keyword wgslType array atomic ptr
syn keyword wgslType sampler sampler_comparison
syn match wgslType "\<texture_\%(1d\|2d\|2d_array\|3d\|cube\|cube_array\|multisampled_2d\|depth_multisampled_2d\|external\)\>"
syn match wgslType "\<texture_storage_\%(1d\|2d\|2d_array\|3d\)\>"
syn match wgslType "\<texture_depth_\%(2d\|2d_array\|cube\|cube_array\)\>"
" Texel formats
syn match wgslType "\<\%(rgba\|rg\|r\)\%(8\|16\|32\)\%(unorm\|snorm\|uint\|sint\|float\)\>"
syn match wgslType "\<bgra8unorm\>"

" Attributes: @vertex, @group(0), @builtin(position), ...
syn match wgslAttribute "@\h\w*"

" Built-in values (used inside @builtin(...))
syn keyword wgslBuiltinValue vertex_index instance_index position front_facing
syn keyword wgslBuiltinValue frag_depth sample_index sample_mask
syn keyword wgslBuiltinValue local_invocation_id local_invocation_index
syn keyword wgslBuiltinValue global_invocation_id workgroup_id num_workgroups
syn keyword wgslBuiltinValue subgroup_invocation_id subgroup_size clip_distances

" Built-in functions
syn keyword wgslBuiltinFunc abs acos acosh all any arrayLength asin asinh atan atan2 atanh
syn keyword wgslBuiltinFunc bitcast ceil clamp cos cosh countLeadingZeros countOneBits
syn keyword wgslBuiltinFunc countTrailingZeros cross degrees determinant distance dot dot4U8Packed dot4I8Packed
syn keyword wgslBuiltinFunc exp exp2 extractBits faceForward firstLeadingBit firstTrailingBit
syn keyword wgslBuiltinFunc floor fma fract frexp insertBits inverseSqrt ldexp length log log2
syn keyword wgslBuiltinFunc max min mix modf normalize pow quantizeToF16 radians reflect refract
syn keyword wgslBuiltinFunc reverseBits round saturate select sign sin sinh smoothstep sqrt step
syn keyword wgslBuiltinFunc tan tanh transpose trunc
syn keyword wgslBuiltinFunc dpdx dpdxCoarse dpdxFine dpdy dpdyCoarse dpdyFine fwidth fwidthCoarse fwidthFine
syn keyword wgslBuiltinFunc pack4x8snorm pack4x8unorm pack4xI8 pack4xU8 pack4xI8Clamp pack4xU8Clamp
syn keyword wgslBuiltinFunc pack2x16snorm pack2x16unorm pack2x16float
syn keyword wgslBuiltinFunc unpack4x8snorm unpack4x8unorm unpack4xI8 unpack4xU8
syn keyword wgslBuiltinFunc unpack2x16snorm unpack2x16unorm unpack2x16float
syn keyword wgslBuiltinFunc storageBarrier textureBarrier workgroupBarrier workgroupUniformLoad
syn keyword wgslBuiltinFunc atomicLoad atomicStore atomicAdd atomicSub atomicMax atomicMin
syn keyword wgslBuiltinFunc atomicAnd atomicOr atomicXor atomicExchange atomicCompareExchangeWeak
syn keyword wgslBuiltinFunc textureDimensions textureGather textureGatherCompare textureLoad
syn keyword wgslBuiltinFunc textureNumLayers textureNumLevels textureNumSamples textureSample
syn keyword wgslBuiltinFunc textureSampleBias textureSampleCompare textureSampleCompareLevel
syn keyword wgslBuiltinFunc textureSampleGrad textureSampleLevel textureSampleBaseClampToEdge textureStore

" Numbers
syn match wgslNumber "\<0[xX][0-9a-fA-F]\+[iu]\?\>"
syn match wgslNumber "\<\d\+[iuhf]\?\>"
syn match wgslFloat  "\<\d\+\.\d*\%([eE][-+]\?\d\+\)\?[hf]\?"
syn match wgslFloat  "\.\d\+\%([eE][-+]\?\d\+\)\?[hf]\?"
syn match wgslFloat  "\<\d\+[eE][-+]\?\d\+[hf]\?"

" Function definitions & calls
syn match wgslFunction "\<\h\w*\ze\s*("
syn match wgslFuncDef "\%(\<fn\s\+\)\@<=\h\w*"

hi def link wgslComment      Comment
hi def link wgslTodo         Todo
hi def link wgslPreProc      PreProc
hi def link wgslDirective    PreProc
hi def link wgslKeyword      Keyword
hi def link wgslBoolean      Boolean
hi def link wgslStorageClass StorageClass
hi def link wgslType         Type
hi def link wgslAttribute    Special
hi def link wgslBuiltinValue Constant
hi def link wgslBuiltinFunc  Function
hi def link wgslFunction     Function
hi def link wgslFuncDef      Function
hi def link wgslNumber       Number
hi def link wgslFloat        Float

let b:current_syntax = "wgsl"
