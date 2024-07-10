function wakeUpJavascriptChannel() {
  DebbugingKushkiCommunication.postMessage();
}

function requestSubscriptionDeviceToken(subscriptionId) {
  if (!kushki) return;
  kushki.requestDeviceToken({
    subscriptionId,
  }, (response) => {

    if (response.token) {
      const resJsonString = `{ "token": "${response.token}" }`;
      SubscriptionChargeSuccess.postMessage(resJsonString);
    } else {
      const errorJsonString = `{ "code": "${response.code}", "error": "${response.error}", "message": "${response.message}" }`;
      SubscriptionChargeFailure.postMessage(errorJsonString);
    }
  });
}

