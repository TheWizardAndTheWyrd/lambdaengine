FROM golang:1.8
MAINTAINER Ramon Long <ramonjlongiii@gmail.com>

# Update our packages
RUN apt-get update && apt-get upgrade -y

# Add make
RUN apt-get install -y make

# Copy the local repo to the container
ADD . /go/src/github.com/TheWizardAndTheWyrd/lambdaengine

# Set the working directory
WORKDIR /go/src/github.com/TheWizardAndTheWyrd/lambdaengine

# Get some useful tools
RUN go get github.com/Masterminds/glide

RUN glide install && \
    cd cmd/lambdaengine && \
    go build -ldflags "-X github.com/TheWizardAndTheWyrd/lambdaengine.versionHash=`git rev-parse --short HEAD`"

# Run the app
CMD ["go", "test", "-v", "./pkg/...", "./cmd/..."]
