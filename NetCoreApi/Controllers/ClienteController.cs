using Microsoft.AspNetCore.Mvc;
using NetCoreApi.Models;
using System.Security.Cryptography;
using System.Text;

namespace NetCoreApi.Controllers
{
    [ApiController]
    [Route("cliente")]
    public class ClienteController : ControllerBase
    {
        // Lista estática para almacenar los clientes
        private static List<Cliente> clientes = new List<Cliente>();

        // Contador estático para asignar IDs únicos
        private static int contadorId = 1;

        [HttpGet]
        [Route("listar")]
        public dynamic listarCliente()
        {
            return clientes;
        }

        [HttpGet]
        [Route("listar/{id}")]
        public dynamic listarClientePorId(string id)
        {
            var cliente = clientes.FirstOrDefault(c => c.id == id);
            if (cliente == null)
            {
                return new
                {
                    success = false,
                    message = "Cliente no encontrado"
                };
            }

            return new
            {
                success = true,
                message = "Cliente encontrado",
                result = cliente
            };
        }

        [HttpPost]
        [Route("guardar")]
        public dynamic guardarClientes(Cliente cliente)
        {
            // Generar un hash encriptado único como ID
            cliente.id = GenerarHashUnico();

            // Agregar el cliente a la lista
            clientes.Add(cliente);

            return new
            {
                success = true,
                message = "Cliente registrado",
                result = cliente
            };
        }

        private string GenerarHashUnico()
        {
            // Usar un identificador único (GUID) como base para el hash
            string guid = Guid.NewGuid().ToString();

            // Encriptar el GUID con SHA256
            using SHA256 sha256 = SHA256.Create();
            byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(guid));
            StringBuilder sb = new StringBuilder();

            // Convertir el hash a una cadena segura (hexadecimal)
            foreach (byte b in bytes)
            {
                sb.Append(b.ToString("x2"));
            }

            return sb.ToString();
        }

        [HttpDelete]
        [Route("eliminar/{id}")]
        public dynamic eliminarCliente(string id)
        {
            var cliente = clientes.FirstOrDefault(c => c.id == id);
            if (cliente == null)
            {
                return new
                {
                    success = false,
                    message = "Cliente no encontrado"
                };
            }

            // Elimina al cliente de la lista
            clientes.Remove(cliente);

            return new
            {
                success = true,
                message = "Cliente eliminado",
                result = cliente
            };
        }
    }
}
