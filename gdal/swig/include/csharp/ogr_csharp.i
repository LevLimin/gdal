/******************************************************************************
 * $Id: ogr_csharp.i 33721 2016-03-15 00:56:01Z goatbar $
 *
 * Name:     ogr_csharp.i
 * Project:  GDAL CSharp Interface
 * Purpose:  OGR CSharp SWIG Interface declarations.
 * Author:   Tamas Szekeres, szekerest@gmail.com
 *
 ******************************************************************************
 * Copyright (c) 2007, Tamas Szekeres
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *****************************************************************************/

%include cpl_exceptions.i

%rename (GetFieldType) GetType;
%rename (GetDriverCount) OGRGetDriverCount;
%rename (GetOpenDSCount) OGRGetOpenDSCount;
%rename (SetGenerate_DB2_V72_BYTE_ORDER) OGRSetGenerate_DB2_V72_BYTE_ORDER;
%rename (RegisterAll) OGRRegisterAll();

%include typemaps_csharp.i

DEFINE_EXTERNAL_CLASS(OSRSpatialReferenceShadow, OSGeo.OSR.SpatialReference)
DEFINE_EXTERNAL_CLASS(OSRCoordinateTransformationShadow, OSGeo.OSR.CoordinateTransformation)
DEFINE_EXTERNAL_CLASS(GDALMajorObjectShadow, OSGeo.GDAL.MajorObject)


%typemap(cscode, noblock="1") OGRGeometryShadow {
  public int ExportToWkb( byte[] buffer, wkbByteOrder byte_order ) {
      int retval;
      int size = WkbSize();
      if (buffer.Length < size)
        throw new global::System.ArgumentException("Buffer size is small (ExportToWkb)");

      global::System.IntPtr ptr = global::System.Runtime.InteropServices.Marshal.AllocHGlobal(size * global::System.Runtime.InteropServices.Marshal.SizeOf(buffer[0]));
      try {
          retval = ExportToWkb(size, ptr, byte_order);
          global::System.Runtime.InteropServices.Marshal.Copy(ptr, buffer, 0, size);
      } finally {
          global::System.Runtime.InteropServices.Marshal.FreeHGlobal(ptr);
      }
      global::System.GC.KeepAlive(this);
      return retval;
  }
  public int ExportToWkb( byte[] buffer ) {
      return ExportToWkb( buffer, wkbByteOrder.wkbXDR);
  }

  public static $csclassname CreateFromWkb(byte[] wkb){
     if (wkb.Length == 0)
        throw new global::System.ArgumentException("Buffer size is small (CreateFromWkb)");
     $csclassname retval;
     global::System.IntPtr ptr = global::System.Runtime.InteropServices.Marshal.AllocHGlobal(wkb.Length * global::System.Runtime.InteropServices.Marshal.SizeOf(wkb[0]));
     try {
         global::System.Runtime.InteropServices.Marshal.Copy(wkb, 0, ptr, wkb.Length);
         retval =  new $csclassname(wkbGeometryType.wkbUnknown, null, wkb.Length, ptr, null);
      } finally {
          global::System.Runtime.InteropServices.Marshal.FreeHGlobal(ptr);
      }
      return retval;
  }

  public static $csclassname CreateFromWkt(string wkt){
     return new $csclassname(wkbGeometryType.wkbUnknown, wkt, 0, global::System.IntPtr.Zero, null);
  }

  public static $csclassname CreateFromGML(string gml){
     return new $csclassname(wkbGeometryType.wkbUnknown, null, 0, global::System.IntPtr.Zero, gml);
  }

  public Geometry(wkbGeometryType type) : this(OgrPINVOKE.new_Geometry((int)type, null, 0, global::System.IntPtr.Zero, null), true, null) {
    if (OgrPINVOKE.SWIGPendingException.Pending) throw OgrPINVOKE.SWIGPendingException.Retrieve();
  }
}
