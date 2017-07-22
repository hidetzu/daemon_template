#Helpers Functions
get_src_from_dir =$(wildcard $1/*.c)
get_src_from_dir_list = $(foreach dir, $1, $(call get_src_from_dir,$(dir)))

__src_to =$(subst .c,$1, $2)
src_to = $(addprefix $(OUTPUT_DIR)/, $(call __src_to,$1,$2))
src_to_o = $(call src_to,.o,$1)
