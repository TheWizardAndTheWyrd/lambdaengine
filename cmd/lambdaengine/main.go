package main

import (
	log "github.com/Sirupsen/logrus"
	"github.com/TheWizardAndTheWyrd/lambdaengine"
	"os"
)

func main() {
	log.Infof("Lambda Engine ver. %v", lambdaengine.GetVersion())
	os.Exit(0)
}
