using UnityEngine;
using System.Collections;

public class XboxCameras : MonoBehaviour {

    public bool A { get; set; }
    public bool B { get; set; }
    public float rTrigger { get; set; }

    bool Btog;

    Color originalColour;

    GameObject CameraLeft, CameraRight, WebcamLeft, WebcamRight;

	// Use this for initialization
	void Start () {
        //CameraLeft = GameObject.Find("CameraLeft");
        //CameraRight = GameObject.Find("CameraRight");
        
        WebcamLeft = GameObject.Find("WebcamLeft");
        WebcamRight = GameObject.Find("WebcamRight");

        GameObject.Find("CameraLeft").camera.cullingMask = ((1 << 30) | (1 << 0)); //1 << 30;
        GameObject.Find("CameraRight").camera.cullingMask = ((1 << 31) | (1 << 0)); //1 << 31;
	}
	
	// Update is called once per frame
	void Update () {

        Debug.Log("Btog: " + Btog);

        A = Input.GetButton("Fire1");
        B = Input.GetButton("Fire2");
        rTrigger = Input.GetAxis("Horizontal");

        if(A && !Btog) {
            originalColour = WebcamLeft.renderer.material.color;
            WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);

            originalColour = WebcamRight.renderer.material.color;
            WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);
        }
        else if (B) {
            Btog = true;

            originalColour = WebcamLeft.renderer.material.color;
            WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(originalColour.a, 0.0f, 0.1f));

            originalColour = WebcamRight.renderer.material.color;
            WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(originalColour.a, 0.0f, 0.1f));
        }
        else if (!B && Btog) {
            
            WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(WebcamLeft.renderer.material.color.a, 1.0f, 0.1f));

            WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(WebcamRight.renderer.material.color.a, 1.0f, 0.1f));
        }
        else if (rTrigger != 0 && !Btog) {
            originalColour = WebcamLeft.renderer.material.color;
            WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1 - rTrigger);

            originalColour = WebcamRight.renderer.material.color;
            WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1 - rTrigger);
        }
        else if (rTrigger == 0 && !Btog) {
            originalColour = WebcamLeft.renderer.material.color;
            WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);

            originalColour = WebcamRight.renderer.material.color;
            WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);
        }

        if (Btog && WebcamLeft.renderer.material.color.a >= 0.95f && WebcamRight.renderer.material.color.a >= 0.95f) {
            Btog = false;
        }

    }
}