# Red's current Object.module_eval is only the block form of eval
# this provides a version that will take a string.
# Works like Ruby's Object.module_eval(str)
# and will return the object represented by
# the the string.
#
# e.g. Object.module_eval_with_string_not_block("Note")
# will return the object <tt>Note</tt> by calling
# window['c$Note']
def Object.module_eval_with_string_not_block(str)
  str = `str.__value__`
  str = `'c$' + str`
  `window[str]`
end