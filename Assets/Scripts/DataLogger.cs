using UnityEngine;
using System.Collections;
using System;
using System.IO;

public class DataLogger : MonoBehaviour {

    //whether logging has been invoked
    public bool activated { get; set; }

    //file to write the log to
    public string filePath;
    StreamWriter file;

    //how many frames between writing lines out to file
    int count;

    //how many frames have elapsed
    uint frame;

    //the player object its two (Unity) camera objects
    GameObject player, leftCam, rightCam, leftWebCamTexture, rightWebCamTexture;

    string timestamp;

    Vector3 position, originalPosition;
    Quaternion leftRotation, rightRotation;
    float leftWebCamTextureOpacity, rightWebCamTextureOpacity, baseOpacity, rTrigger, autoSwitchSpacing, autoSwitchDuration, deltaX, deltaZ;
    bool A, B, autoTick, firstRun;

    //for calculating FPS
    float deltaTime = 0.0f;
    float fps;

    // <frame> <timestamp> <original_position> <position> <delta_x> <delta_z> <leftRotation> <rightRotation> <baseOpacity> <leftWebCamTextureOpacity>
    // <rightWebCamOpacity> <autoTick> <autoSwitchDuration> <autoSwitchSpacing> <fps> <A button> <B button> <rTrigger>
    string lines;

    void Start () {
        activated = false;
        firstRun = true;
        timestamp = DateTime.Now.ToString("dd-MM-yyyy HH-mm-ss-fff");
        filePath = "Mirrorshades " + timestamp + ".log";
	    player = GameObject.Find("OVRPlayerController3");
        leftCam = GameObject.Find("CameraLeft");
        rightCam = GameObject.Find("CameraRight");
        leftWebCamTexture = GameObject.Find("WebcamLeft");
        rightWebCamTexture = GameObject.Find("WebcamRight");

        //write header to log
        file = new StreamWriter(filePath, true);
        file.Write("\"frame\"\t\"timestamp\"\t\"original_position\"\t\"position\"\t\"delta_x\"\t\"delta_z\"\t\"left_rotation\"\t\"right_rotation\"\t\"base_oapcity\"\t\"left_opacity" + 
            "\"\t\"right_opacity\"\t\"auto_tick\"\t\"auto_duration\"\t\"auto_spacing\"\t\"framerate\"\t\"A_button\"\t\"B_button\"\t\"right_trigger\"\n");
        file.Close();
	}
	
	void Update () {

        if (!activated) {
            return;
        }

        if (firstRun) {
            originalPosition = player.transform.position;
            firstRun = false;
        }

        timestamp = DateTime.Now.ToString("dd-MM-yyyy HH-mm-ss-fff");

        //calculate FPS
        deltaTime += (Time.deltaTime - deltaTime) * 0.1f;
        fps = 1.0f / deltaTime;

        //get details about player position/orientation/opacity
        position = player.transform.position;
        deltaX = Math.Abs(originalPosition.x - position.x);
        deltaZ = Math.Abs(originalPosition.z - position.z);
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
        lines += ((frame + "\t" + timestamp + "\t" + originalPosition + "\t" + position + "\t" + deltaX + "\t" + deltaZ + "\t" + leftRotation + "\t"
              + rightRotation + "\t" + baseOpacity + "\t" + leftWebCamTextureOpacity + "\t" + rightWebCamTextureOpacity + "\t" + autoTick + "\t"
              + autoSwitchDuration + "\t" + autoSwitchSpacing + "\t" +  fps + "\t" + A + "\t" + B + "\t" + rTrigger + "\n"));

        //on each certain multiple of frames, write the contents of lines out to a file & then clear lines
        if (count == 100) {
            //write lines to file
            file = new StreamWriter(filePath, true);
            file.Write(lines);
            file.Close();

            count = -1;
            lines = "";
        }
        
        ++count;
        ++frame;

	}

    void OnApplicationQuit() {
        file.Close();
    }
}
