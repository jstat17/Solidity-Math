pragma solidity ^0.5.0;

import "./FixidityLib.sol";

/**
 * @title NumericalMath
 * @author John Michael Statheros (GitHub: jstat17)
 * @notice This library builds on the fixed-point math in FixidityLib with
 * numerical approximations to trigonometric functions, the value of pi etc.
 */

library NumericalMath {
    /**
     * @notice Returns value of pi to 24 digits of precision.
    */
    function pi() public pure returns(int256) {
        return 3141592653589793238462643;
    }
    
    function sin(int256 theta, uint8 digits) public pure returns(int256){
        int256 x = FixidityLib.newFixed(theta, digits);
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2),pi());
        int256 _3_2pi = FixidityLib.multiply(pi(), FixidityLib.newFixedFraction(3, 2));
        x = normAngle(x);
        int256 temp = FixidityLib.abs(FixidityLib.subtract(x, pi()));
        
        if (FixidityLib.subtract(x, pi()) < 0 && FixidityLib.subtract(x, FixidityLib.divide(pi(), FixidityLib.newFixed(2))) > 0) { // > 90 deg and < 180 deg
            //x = FixidityLib.add(temp, FixidityLib.multiply(temp, FixidityLib.newFixed(2)));
            x = temp;
        } else if (FixidityLib.subtract(x, pi()) > 0 && FixidityLib.subtract(x, _3_2pi) < 0) { // > 180 deg and < 270 deg
            x = FixidityLib.subtract(temp, FixidityLib.multiply(temp, FixidityLib.newFixed(2)));
        } else if(FixidityLib.subtract(x, _3_2pi) > 0) { // > 270 deg and < 360 deg
            x = FixidityLib.subtract(x, _2pi);
        }
        
        int256 x_3 = FixidityLib.multiply(FixidityLib.multiply(x, x), x);
        int256 x_5 = FixidityLib.multiply(FixidityLib.multiply(x_3, x), x);
        
        int256 a = FixidityLib.subtract(x, FixidityLib.divide(x_3, FixidityLib.newFixed(6)));
        int256 b = FixidityLib.add(a, FixidityLib.divide(x_5, FixidityLib.newFixed(120)));
        return b;
    }
    
    function cos(int256 theta, uint8 digits) public pure returns(int256){
        int256 x = FixidityLib.newFixed(theta, digits);
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2),pi());
        int256 _3_2pi = FixidityLib.multiply(pi(), FixidityLib.newFixedFraction(3, 2));
        x = normAngle(x);
        int256 temp = FixidityLib.abs(FixidityLib.subtract(x, pi()));
        int8 c = 1;
        
        if (FixidityLib.subtract(x, pi()) < 0 && FixidityLib.subtract(x, FixidityLib.divide(pi(), FixidityLib.newFixed(2))) > 0) { // > 90 deg and < 180 deg
            x = temp;
            c = -1;
        } else if (FixidityLib.subtract(x, pi()) > 0 && FixidityLib.subtract(x, _3_2pi) < 0) { // > 180 deg and < 270 deg
            x = FixidityLib.subtract(temp, FixidityLib.multiply(temp, FixidityLib.newFixed(2)));
            c = -1;
        } else if(FixidityLib.subtract(x, _3_2pi) > 0) { // > 270 deg and < 360 deg
            x = FixidityLib.subtract(x, _2pi);
        }
        
        int256 x_2 = FixidityLib.multiply(x, x);
        int256 x_4 = FixidityLib.multiply(x_2, x_2);
        
        int256 a = FixidityLib.subtract(FixidityLib.fixed1(), FixidityLib.divide(x_2, FixidityLib.newFixed(2)));
        int256 b = FixidityLib.add(a, FixidityLib.divide(x_4, FixidityLib.newFixed(24)));
        return b*c;
    }
    
    function normAngle(int256 x) internal pure returns(int256) {
        int256 _2pi = FixidityLib.multiply(FixidityLib.newFixed(2),pi());
        bool k = false;
        while (!k) {
            int256 x_sub2pi = FixidityLib.subtract(x, _2pi);
            if (x_sub2pi > 0) {
                x = x_sub2pi;
                continue;
            }
            
            int256 x_add2pi = FixidityLib.add(x, _2pi);
            if (x_add2pi < 0) {
                x = x_add2pi;
                continue;
            }
            
            k = !k;
        }
        return x;
    }
}