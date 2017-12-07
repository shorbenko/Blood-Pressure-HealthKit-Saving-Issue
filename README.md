
Blood Pressure sample is not saved if added when phone is locked and System Passcode is set

1. Compile and Run example
2. Clear Logs in Xcode
3. Press 'Launch Timer' button
4. Lock your iPhone
5. Wait 20 seconds
6. Unlock iPhone 
7. Press 'View Blood Pressure Readings' button

Actual results in logs (unable to read blood pressure sample):
```
Timer Scheduled!
Application Did Enter Background: <UIApplication: 0x1054009f0>
Timer Fires!
Blood Pressure sample saved: <HKCorrelation>   (2017-12-07 08:11:08 -0500 - 2017-12-07 08:11:08 -0500) (2 objects)
Blood Pressure Anchored Object Query results: (
), error: (null)
```
Expected results in logs:
```
Timer Scheduled!
Application Did Enter Background: <UIApplication: 0x1054009f0>
Timer Fires!
Blood Pressure sample saved: <HKCorrelation>   (2017-12-07 08:04:39 -0500 - 2017-12-07 08:04:39 -0500) (2 objects)
Blood Pressure Anchored Object Query results: (
    "<HKCorrelation>  B99ED60C-6AA3-43BA-8A9A-C15F561D3AFF \"Blood-Pressure-HealthKit-Saving-Issue\" (1), \"iPhone8,4\" (11.0.1) (2017-12-07 08:04:39 -0500 - 2017-12-07 08:04:39 -0500) (2 objects)"
), error: (null)
```
