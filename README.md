### Descripción de Requisitos Funcionales y No Funcionales para la Aplicación "Buscando Farmacias Chilenas"

#### Requisitos Funcionales

1. **Pantalla de Inicio (Splash Screen):**
   - La aplicación debe mostrar una pantalla de inicio durante el arranque, que incluya un ícono representativo de la aplicación y un indicador de progreso.

2. **Pantalla de Bienvenida:**
   - La aplicación debe mostrar una pantalla de bienvenida que permita al usuario navegar hacia la pantalla principal o a la sección "Acerca de".

3. **Pantalla Principal:**
   - La pantalla principal debe proporcionar acceso a diferentes secciones de la aplicación mediante tarjetas de navegación:
     - Inicio
     - Historial
     - Perfil
     - Farmacias de Turno
     - Farmacias Cercanas
     - Configuración

4. **Pantalla de Farmacias Cercanas:**
   - La aplicación debe mostrar una lista de farmacias cercanas al usuario.
   - Debe manejar los estados de carga y error adecuadamente.
   - Las tarjetas de farmacia deben mostrar información detallada como nombre, dirección y comuna.

5. **Pantalla de Farmacias de Turno:**
   - La aplicación debe mostrar farmacias de turno agrupadas por comuna y localidad.
   - Los usuarios deben poder seleccionar una comuna y localidad para ver las farmacias disponibles.
   - Las tarjetas de farmacia deben mostrar si la farmacia está abierta o cerrada y permitir navegar a una pantalla de detalles.

6. **Pantalla de Detalles de Farmacia:**
   - La aplicación debe mostrar información detallada sobre una farmacia seleccionada, incluyendo la dirección, comuna, horario y teléfono.
   - Debe proporcionar un botón para abrir la ubicación en Google Maps.

7. **Pantalla de Historial:**
   - La aplicación debe mantener un historial de visitas a farmacias.
   - Debe mostrar una lista de acciones de historial con detalles sobre cada visita.
   - Los usuarios deben poder eliminar entradas del historial.

8. **Pantalla de Perfil:**
   - La aplicación debe permitir la gestión de perfiles de usuario.
   - Debe proporcionar formularios para agregar o editar perfiles, y la capacidad de eliminar perfiles.

9. **Pantalla de Configuración:**
   - La aplicación debe ofrecer opciones para gestionar el perfil de usuario y ver el about.

10. **Pantalla de Acerca de:**
    - La aplicación debe mostrar información sobre el equipo de desarrollo y agradecimientos.

#### Requisitos No Funcionales

1. **Usabilidad:**
   - La aplicación debe ser fácil de usar y navegar, con una interfaz clara y coherente.
   - Los textos deben ser legibles y los elementos interactivos accesibles.

2. **Rendimiento:**
   - La aplicación debe cargar y responder a las interacciones del usuario de manera eficiente.
   - Las transiciones entre pantallas deben ser suaves.

3. **Seguridad:**
   - Los datos de los usuarios deben ser manejados de manera segura.
   - Debe evitarse el acceso no autorizado a la base de datos.

4. **Compatibilidad:**
   - La aplicación debe ser compatible con dispositivos Android.
   - Debe adaptarse correctamente a diferentes tamaños de pantalla y resoluciones.

5. **Confiabilidad:**
   - La aplicación debe manejar adecuadamente los errores y fallos, mostrando mensajes de error informativos al usuario.
   - Debe asegurar la persistencia correcta de los datos.

6. **Mantenibilidad:**
   - El código de la aplicación debe estar bien estructurado y documentado para facilitar el mantenimiento y la extensión futura.
   - Las funcionalidades deben estar desacopladas y modularizadas para facilitar las pruebas y actualizaciones.

7. **Portabilidad:**
   - La aplicación debe poder ser trasladada y ejecutada en otros dispositivos con modificaciones mínimas.

8. **Estética:**
   - La aplicación debe tener un diseño visual atractivo, con un esquema de colores coherente y elementos visuales de alta calidad.

9. **Accesibilidad:**
   - La aplicación debe ser accesible para usuarios con diferentes capacidades, incluyendo soporte para texto alternativo y opciones de alto contraste.

10. **Escalabilidad:**
    - La aplicación debe poder manejar un aumento en la cantidad de datos o usuarios sin una disminución significativa en el rendimiento.

Estos requisitos aseguran que la aplicación "Buscando Farmacias Chilenas" sea funcional, segura y agradable para los usuarios, además de ser mantenible y escalable para el equipo de desarrollo.


API TEST: https://drive.google.com/file/d/1IGz0DZzuFTY1V-LSj60ZxSiseX_SOjCd/view?usp=sharing

VIDEO: https://drive.google.com/file/d/1A50Q71xQH9EA6U4jT2jzm6yiurD4siqX/view?usp=sharing

github: https://github.com/ignacioMatus94/buscando_farmacias_chilenas
