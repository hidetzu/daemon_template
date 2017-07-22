ifdef OUTPUT_DIR
	OUTPUT_DIR=work
endif

GCOV_OUTPUT = gcov_output.txt
LCOV_HTML_OUTPUT_DIR=$(OUTPUT_DIR)/lcov_html

.PHONY: lcov gcov

lcov:gcov
	@lcov -c -d $(OUTPUT_DIR) -o $(OUTPUT_DIR)/$(TARGET).info
	@mkdir -p $(LCOV_HTML_OUTPUT_DIR)
	@genhtml -o $(LCOV_HTML_OUTPUT_DIR) $(OUTPUT_DIR)/$(TARGET).info

gcov:
	@for d in $(SRC_DIR); do \
		gcov --object-directory $(OUTPUT_DIR)/$$d $$d/*.c >> $(OUTPUT_DIR)/$(GCOV_OUTPUT); \
		done

#gcov:
#	@for d in $(SRC_DIR); do \
#		gcov --object-directory $(OUTPUT_DIR)/$$d $$d/*.c >> $(OUTPUT_DIR)/$(GCOV_OUTPUT); \
#	done
