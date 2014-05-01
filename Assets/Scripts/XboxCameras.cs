using UnityEngine;
using System.Collections;

public class XboxCameras : MonoBehaviour {

    public bool A { get; set; }
    public bool B { get; set; }
    public float rTrigger { get; set; }

    public float autoSwitchSpacing, autoSwitchDuration;

    bool Btog, autoTick, postSwitch;

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

        postSwitch = false;

        if (autoSwitchSpacing > 0 && autoSwitchDuration > 0) {
            autoTick = false;
            StartCoroutine("AutoSwitch");
        }

	}
	
	// Update is called once per frame
	void Update () {

        A = Input.GetButton("Fire1");
        B = Input.GetButton("Fire2");
        rTrigger = Input.GetAxis("Horizontal");

        if (!autoTick) {

            //switching to VR
            if (A && !Btog) {
                originalColour = WebcamLeft.renderer.material.color;
                WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);

                originalColour = WebcamRight.renderer.material.color;
                WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);
            }
            //switching to virtual
            else if (B) {
                Btog = true;

                originalColour = WebcamLeft.renderer.material.color;
                WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(originalColour.a, 0.0f, 0.1f));

                originalColour = WebcamRight.renderer.material.color;
                WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(originalColour.a, 0.0f, 0.1f));
            }
            //switching to RW
            else if (!B && Btog) {
                WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(WebcamLeft.renderer.material.color.a, 1.0f, 0.1f));

                WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, Mathf.Lerp(WebcamRight.renderer.material.color.a, 1.0f, 0.1f));
            }
            //switching to trigger (VR or mix)
            else if (rTrigger != 0 && !Btog) {
                originalColour = WebcamLeft.renderer.material.color;
                WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1 - rTrigger);

                originalColour = WebcamRight.renderer.material.color;
                WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1 - rTrigger);
            }
            //switching to RW
            else if (rTrigger == 0 && !Btog) {
                originalColour = WebcamLeft.renderer.material.color;
                WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);

                originalColour = WebcamRight.renderer.material.color;
                WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);
            }

            if (Btog && WebcamLeft.renderer.material.color.a >= 0.95f && WebcamRight.renderer.material.color.a >= 0.95f) {
                Btog = false;
            }

            if (A || B || rTrigger > 0 || Btog) {
                postSwitch = true;
            }
        }   
    }

    /*
     * Momentarily switch the view from RW to VR every <seconds> seconds.
     */
    IEnumerator AutoSwitch() {

        while (true) {
            if (autoTick) {
                if (!A && !B && rTrigger == 0 && !Btog) {
                    autoTick = false;

                    originalColour = WebcamLeft.renderer.material.color;
                    WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);

                    originalColour = WebcamRight.renderer.material.color;
                    WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);
                }
                yield return new WaitForSeconds(autoSwitchSpacing);
            }
            else if (!autoTick) {
                if (!A && !B && rTrigger == 0 && !Btog) {
                    autoTick = true;

                    //don't do a flash if we have only just returned to RW from a manually triggered switch/mix to VR
                    if (postSwitch) {
                        postSwitch = false;
                        yield return new WaitForSeconds(autoSwitchSpacing);
                    }

                    originalColour = WebcamLeft.renderer.material.color;
                    WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);

                    originalColour = WebcamRight.renderer.material.color;
                    WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);
                }
                yield return new WaitForSeconds(autoSwitchDuration);
            }


            //Debug.Log("foo");

            //originalColour = WebcamLeft.renderer.material.color;
            //WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);

            //originalColour = WebcamRight.renderer.material.color;
            //WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);

            ////wait for half a second
            //System.Threading.Thread.Sleep(2000);
            //new WaitForSeconds(2.0f);

            //Debug.Log("bar");

            ////switch back to RW
            //originalColour = WebcamLeft.renderer.material.color;
            //WebcamLeft.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);

            //originalColour = WebcamRight.renderer.material.color;
            //WebcamRight.renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1.0f);

            //yield return new WaitForSeconds(2.0f);
        }

    }

}