using System;
using UnityEngine;

/// <summary>
/// 1、控制机翼滚筒侧向
/// 2、控制尾翼转向
/// </summary>
#pragma warning disable 649
namespace UnityStandardAssets.Vehicles.Aeroplane
{
    public class AeroplaneControlSurfaceAnimator : MonoBehaviour
    {
        [SerializeField,Header("平滑应用于控制表面的运动")] 
        private float m_Smoothing = 5f; // The smoothing applied to the movement of control surfaces.
        [SerializeField] private ControlSurface[] m_ControlSurfaces; // Collection of control surfaces.

        private AeroplaneController m_Plane; // Reference to the aeroplane controller.


        private void Start()
        {
            // Get the reference to the aeroplane controller.
            m_Plane = GetComponent<AeroplaneController>();

            // Store the original local rotation of each surface, so we can rotate relative to this
            foreach (var surface in m_ControlSurfaces)
            {
                surface.originalLocalRotation = surface.transform.localRotation;
            }
        }


        private void Update()
        {
            foreach (var surface in m_ControlSurfaces)
            {
                switch (surface.type)
                {
                    case ControlSurface.Type.Aileron:
                        {
                            // Ailerons rotate around the x axis, according to the plane's roll input
                            Quaternion rotation = Quaternion.Euler(surface.amount*m_Plane.RollInput, 0f, 0f);
                            RotateSurface(surface, rotation);
                            break;
                        }
                    case ControlSurface.Type.Elevator:
                        {
                            // Elevators rotate negatively around the x axis, according to the plane's pitch input
                            Quaternion rotation = Quaternion.Euler(surface.amount*-m_Plane.PitchInput, 0f, 0f);
                            RotateSurface(surface, rotation);
                            break;
                        }
                    case ControlSurface.Type.Rudder:
                        {
                            // Rudders rotate around their y axis, according to the plane's yaw input
                            Quaternion rotation = Quaternion.Euler(0f, surface.amount*m_Plane.YawInput, 0f);
                            RotateSurface(surface, rotation);
                            break;
                        }
                    case ControlSurface.Type.RuddervatorPositive:
                        {
                            // Ruddervators are a combination of rudder and elevator, and rotate
                            // around their z axis by a combination of the yaw and pitch input
                            float r = m_Plane.YawInput + m_Plane.PitchInput;
                            Quaternion rotation = Quaternion.Euler(0f, 0f, surface.amount*r);
                            RotateSurface(surface, rotation);
                            break;
                        }
                    case ControlSurface.Type.RuddervatorNegative:
                        {
                            // ... and because ruddervators are "special", we need a negative version too. >_<
                            float r = m_Plane.YawInput - m_Plane.PitchInput;
                            Quaternion rotation = Quaternion.Euler(0f, 0f, surface.amount*r);
                            RotateSurface(surface, rotation);
                            break;
                        }
                }
            }
        }


        private void RotateSurface(ControlSurface surface, Quaternion rotation)
        {
            // Create a target which is the surface's original rotation, rotated by the input.
            Quaternion target = surface.originalLocalRotation*rotation;

            // Slerp the surface's rotation towards the target rotation.
            surface.transform.localRotation = Quaternion.Slerp(surface.transform.localRotation, target,
                                                               m_Smoothing*Time.deltaTime);
        }


        // This class presents a nice custom structure in which to define each of the plane's contol surfaces to animate.
        // They show up in the inspector as an array.
        [Serializable]
        public class ControlSurface // Control surfaces represent the different flaps of the aeroplane.
        {
            public enum Type // Flaps differ in position and rotation and are represented by different types.
            {
                /// <summary>
                /// 【水平襟翼】
                /// Horizontal flaps on the wings, rotate on the x axis.机翼上的水平襟翼在x轴上旋转
                /// </summary>
                Aileron,

                /// <summary>
                /// 用于调整平面间距的水平襟翼在x轴上旋转。(+-30)
                /// </summary>
                Elevator,

                /// <summary>
                /// 【垂直襟翼】
                /// Vertical flaps on the tail, rotate on the y axis.尾部的垂直襟翼在y轴上旋转。
                /// </summary>
                Rudder,

                /// <summary>
                /// Combination of rudder and elevator.转向尾翼L(+30)
                /// </summary>
                RuddervatorNegative,

                /// <summary>
                /// Combination of rudder and elevator.转向尾翼R(-30)
                /// </summary>
                RuddervatorPositive,
            }

            public Transform transform; // The transform of the control surface.
            public float amount; // The amount by which they can rotate.
            public Type type; // The type of control surface.

            [HideInInspector] public Quaternion originalLocalRotation; // The rotation of the surface at the start.
        }
    }
}
