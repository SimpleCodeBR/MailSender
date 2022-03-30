using System;

namespace SimpleCode.MailSender.Data
{
    internal static class Util
    {
        public static object ToDbValue(Int16 value)
        {
            if (value == Int16.MinValue)
                return DBNull.Value;
            return value;
        }

        public static object ToDbValue(Int32 value)
        {
            if (value == int.MinValue)
                return DBNull.Value;
            return value;
        }

        public static object ToDbValue(string value)
        {
            if (string.IsNullOrEmpty(value))
                return DBNull.Value;
            return value;
        }

        public static object ToDbValue(DateTime value)
        {
            if (value == DateTime.MinValue)
                return DBNull.Value;
            return value;
        }

        public static object ToDbValue(decimal value)
        {
            if (value == decimal.MinValue)
                return DBNull.Value;
            return value;
        }

        public static object ToDbValue(bool? value)
        {
            if (!value.HasValue)
                return DBNull.Value;
            return value;
        }

        public static string ToString(object obj)
        {
            if (obj == DBNull.Value)
                return string.Empty;
            return obj.ToString();
        }

        public static char ToChar(object obj)
        {
            if (obj == DBNull.Value)
                return char.MinValue;
            return char.Parse((string)obj);
        }

        public static Int16 ToInt16(object obj)
        {
            if (obj == DBNull.Value)
                return Int16.MinValue;
            Int16 i;
            Int16.TryParse(obj.ToString(), out i);
            return i;
        }

        public static int ToInt32(object obj)
        {
            if (obj == DBNull.Value)
                return int.MinValue;
            int i;
            int.TryParse(obj.ToString(), out i);
            return i;
        }

        public static decimal ToDecimal(object obj)
        {
            if (obj == DBNull.Value)
                return decimal.MinValue;
            decimal i;
            decimal.TryParse(obj.ToString(), out i);
            return i;
        }

        public static float ToFloat(object obj)
        {
            if (obj == DBNull.Value)
                return float.MinValue;
            float f;
            float.TryParse(obj.ToString(), out f);
            return f;
        }

        public static bool ToBoolean(object obj)
        {
            if (obj == DBNull.Value)
                return false;
            return Convert.ToBoolean(obj);
        }

        public static bool? ToNullableBoolean(object obj)
        {
            if(obj == DBNull.Value)
                return new Nullable<bool>();
            return (bool?)obj;
        }

        public static DateTime ToDateTime(object obj)
        {
            if (obj == DBNull.Value)
                return DateTime.MinValue;
            return Convert.ToDateTime(obj);            
        }
    }
}