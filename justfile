# Set shell to bash for better error handling
set shell := ["bash", "-c"]

# pust to github
@push:
    git add .
    @read -p "Enter commit message (leave empty for default): " msg; \
    if [ -z "$msg" ]; then \
        msg="Update: $(date +'%Y-%m-%d %H:%M:%S')"; \
        echo "Using default message: $msg"; \
    fi; \
    git commit -m "$msg"; \
    git push