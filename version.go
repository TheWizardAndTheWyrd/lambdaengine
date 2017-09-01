package lambdaengine

import log "github.com/Sirupsen/logrus"

var versionHash string

func GetVersion() string {
     log.Debug("Returning version hash: %s", versionHash)
     			  return versionHash
}