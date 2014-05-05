using UnityEngine;
using System.Collections;
using System;
using System.IO;

public class DataLogger : MonoBehaviour {

    //file to write the log to
    public string filePath;
    StreamWriter file;

    //how many frames between writing lines out to file
    int count;

    //the player object its two (Unity) camera objects
    GameObject player, leftCam, rightCam, leftWebCamTexture, rightWebCamTexture;

    string timestamp;

    Vector3 position;
    Quaternion leftRotation, rightRotation;
    float leftWebCamTextureOpacity, rightWebCamTextureOpacity, baseOpacity, rTrigger, autoSwitchSpacing, autoSwitchDuration;
    bool A, B, autoTick;

    //for calculating FPS
    float deltaTime = 0.0f;
    float fps;

    // <timestamp> <position> <leftRotation> <rightRotation> <baseOpacity> <leftWebCamTextureOpacity> <rightWebCamOpacity>
    // <autoTick> <autoSwitchDuration> <autoSwitchSpacing> <fps> <A button> <B button> <rTrigger>
    string lines;

    void Start () {
        timestamp = DateTime.Now.ToString("dd-MM-yyyy HH-mm-ss-fff");
        filePath = "Mirrorshades " + timestamp + ".log";
	    player = GameObject.Find("OVRPlayerController2");
        leftCam = GameObject.Find("CameraLeft");
        rightCam = GameObject.Find("CameraRight");
        leftWebCamTexture = GameObject.Find("WebcamLeft");
        rightWebCamTexture = GameObject.Find("WebcamRight");
	}
	
	void Update () {

        timestamp = DateTime.Now.ToString("dd-MM-yyyy HH-mm-ss-fff");

        //calculate FPS
        deltaTime += (Time.deltaTime - deltaTime) * 0.1f;
        fps = 1.0f / deltaTime;

        //get details about player position/orientation/opacity
        position = player.transform.position;
        leftRotation = leftCam.transform.rotation;
        rightRotation = rightCam.transform.rotation;
        baseOpacity = player.GetComponent<XboxCameras>().baseOpacity;
        leftWebCamTextureOpacity = leftWebCamTexture.renderer.material.color.a;
        rightWebCamTextureOpacity = rightWebCamTexture.renderer.material.color.a;
        autoTick = player.GetComponent<XboxCameras>().autoTick;
        autoSwitchDuration = player.GetComponent<XboxCameras>().autoSwitchDuration;
        autoSwitchSpacing = player.GetComponent<XboxCameras>().autoSwitchSpacing;
        A = player.GetComponent<XboxCameras>().A;
        B = player.GetComponent<XboxCameras>().B;
        rTrigger = player.GetComponent<XboxCameras>().rTrigger;

        //assembling the current frame's log line
        lines += ((timestamp + " " + position + " " + leftRotation + " " + rightRotation + " " + baseOpacity + " " + leftWebCamTextureOpacity
             + " " + rightWebCamTextureOpacity + " " + autoTick + " " + autoSwitchDuration + " " + autoSwitchSpacing + " " +  fps
             + " " + A + " " + B + " " + rTrigger + "\n"));

        //on each certain multiple of frames, write the contents of lines out to a file & then clear lines
        if (count == 100) {
            //write lines to file
            file = new StreamWriter(filePath, true);
            file.WriteLine(lines);
            file.Close();

            count = -1;
            lines = "";
        }
        
        ++count;
	}

    void OnApplicationQuit() {
        file.Close();
    }
}
