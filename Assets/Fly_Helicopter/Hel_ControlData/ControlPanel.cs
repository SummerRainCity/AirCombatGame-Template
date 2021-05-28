using System;
using System.Collections.Generic;
using UnityEngine;

public class ControlPanel : MonoBehaviour
{
    public AudioSource MusicSound;

    [SerializeField, Header("加油门")]
    KeyCode SpeedUp = KeyCode.LeftShift;
    [SerializeField, Header("降油门")]
    KeyCode SpeedDown = KeyCode.Space;
    [SerializeField, Header("前仰")]
    KeyCode Forward = KeyCode.W;
    [SerializeField, Header("后仰")]
    KeyCode Back = KeyCode.S;
    [SerializeField, Header("左仰")]
    KeyCode Left = KeyCode.A;
    [SerializeField, Header("右仰")]
    KeyCode Right = KeyCode.D;
    [SerializeField, Header("机身左转")]
    KeyCode TurnLeft = KeyCode.Q;
    [SerializeField, Header("机身右转")]
    KeyCode TurnRight = KeyCode.E;
    [SerializeField, Header("背景音乐")]
    KeyCode MusicOffOn = KeyCode.M;

    private KeyCode[] keyCodes;

    public Action<PressedKeyCode[]> KeyPressed;
    private void Awake()
    {
        keyCodes = new[] {
                            SpeedUp,
                            SpeedDown,
                            Forward,
                            Back,
                            Left,
                            Right,
                            TurnLeft,
                            TurnRight
                        };

    }

    void Start()
    {

    }

    void FixedUpdate()
    {
        var pressedKeyCode = new List<PressedKeyCode>();
        for (int index = 0; index < keyCodes.Length; index++)
        {
            var keyCode = keyCodes[index];
            if (Input.GetKey(keyCode))
                pressedKeyCode.Add((PressedKeyCode)index);
        }

        if (KeyPressed != null)
            KeyPressed(pressedKeyCode.ToArray());

        // for test
        if (Input.GetKey(MusicOffOn))
        {
            if (MusicSound)
            {
                if (MusicSound.volume == 1) return;
                /* if (MusicSound.isPlaying)
                      MusicSound.Stop();
                else*/
                MusicSound.volume = 1;
                MusicSound.Play();
            }
        }

    }
}
