# ==============================================================================
# make all/pdf/epub/mobi/clean
# ==============================================================================
GITBOOK = gitbook
RM = rm

TARGET = a_byte_of_seandroid
FORMATS = pdf epub mobi

.PHONY: all clean html $(FORMATS)

all: html $(FORMATS)

html:
	$(GITBOOK) build . $(TARGET)_html

$(FORMATS):
	$(GITBOOK) $@ . $(TARGET).$@

clean:
	-$(RM) -f $(addprefix $(TARGET)., $(FORMATS))
	-$(RM) -rf $(TARGET)_html

