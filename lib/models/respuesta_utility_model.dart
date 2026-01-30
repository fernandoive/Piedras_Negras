class RespuestaUtilityModel {

  bool          error;
  String        mensaje;
  bool timeout;

  RespuestaUtilityModel(
    {
      this.error = false,
      this.mensaje = '',
      this.timeout = false,
    }
  );

}