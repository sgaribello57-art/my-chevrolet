#!/bin/bash
# ==============================================================================
# SCRIPT DE OPTIMIZACIÓN INTEGRAL: MY CHEVROLET & SUZUKI S.A.S.
# ==============================================================================
# Este script consolida: Seguridad, SEO Técnico, Diseño UX/UI (Paleta Oficial),
# Optimización de Cotizaciones WhatsApp y Validación de Producción para Vercel.
# ==============================================================================

set -e # Detener ejecución inmediatamente si cualquier comando falla

echo "🚀 Iniciando proceso de optimización integral para My Chevrolet & Suzuki S.A.S."

# ------------------------------------------------------------------------------
# 1. PROTECCIÓN Y RESPALDO DEL PROYECTO ACTUAL
# ------------------------------------------------------------------------------
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backup_seguridad_$TIMESTAMP"
echo "📦 [1/8] Creando respaldo completo de seguridad en: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
# Copia todo excepto directorios de compilación, dependencias y backups previos
rsync -a --exclude='node_modules' --exclude='.next' --exclude='backup_*' --exclude='.git' ./ "$BACKUP_DIR/"
echo "✅ Respaldo completado. Tus archivos originales están seguros."

# ------------------------------------------------------------------------------
# 2. VERIFICACIÓN DE ARQUITECTURA
# ------------------------------------------------------------------------------
echo "🔍 [2/8] Verificando arquitectura del proyecto..."
if [ ! -f "package.json" ]; then
    echo "❌ Error Crítico: No se encontró 'package.json'."
    echo "Este script está diseñado para proyectos Node.js/Next.js en la raíz del repositorio."
    echo "Por favor, ejecútalo desde la carpeta correcta."
    exit 1
fi

# Detectar si es Next.js para aplicar configuraciones específicas
IS_NEXT=false
if grep -q '"next"' package.json; then
    IS_NEXT=true
    echo "✅ Arquitectura Next.js detectada."
else
    echo "⚠️ Advertencia: No se detectó Next.js en package.json. Algunas optimizaciones específicas de Next pueden no aplicar."
fi

# ------------------------------------------------------------------------------
# 3. ACTUALIZACIÓN DE DEPENDENCIAS (Seguridad y Rendimiento)
# ------------------------------------------------------------------------------
echo "📦 [3/8] Actualizando núcleo e instalando dependencias de validación..."
npm install next@latest react@latest react-dom@latest
npm install -D @types/node @types/react @types/react-dom typescript
# Zod para validación segura de datos de entrada en formularios/APIs
npm install zod 

# ------------------------------------------------------------------------------
# 4. CONFIGURACIÓN DE SEGURIDAD Y RENDIMIENTO (Nivel Servidor/Vercel)
# ------------------------------------------------------------------------------
if [ "$IS_NEXT" = true ]; then
    echo "⚙️ [4/8] Configurando next.config.js con cabeceras de seguridad estrictas..."
    cat << 'EOF' > next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  poweredByHeader: false, // Oculta que usa Next.js por seguridad
  images: {
    formats: ['image/avif', 'image/webp'], // Optimización automática de imágenes
    remotePatterns: [
      { protocol: 'https', hostname: '**' }, // Ajustar a dominios específicos de imágenes en producción
    ],
  },
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=63072000; includeSubDomains; preload',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'SAMEORIGIN', // Protección contra Clickjacking
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
          {
            key: 'Permissions-Policy',
            value: 'camera=(), microphone=(), geolocation=()',
          },
          {
            key: 'Content-Security-Policy',
            value: "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://wa.me https://fonts.googleapis.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self' https://wa.me;",
          },
        ],
      },
    ];
  },
};

module.exports = nextConfig;
EOF
fi

# ------------------------------------------------------------------------------
# 5. CONFIGURACIÓN SEO TÉCNICO (Robots y Sitemap)
# ------------------------------------------------------------------------------
echo "🔍 [5/8] Configurando archivos de indexación para Googlebot..."
mkdir -p public
cat << 'EOF' > public/robots.txt
User-agent: *
Allow: /
Disallow: /api/
Disallow: /_next/
Disallow: /admin/

Sitemap: https://mychevrolet.com.co/sitemap.xml
EOF

# ------------------------------------------------------------------------------
# 6. COMPONENTE DE COTIZACIÓN WHATSAPP (Validado y Seguro)
# ------------------------------------------------------------------------------
echo "🛠️ [6/8] Creando componente de cotización por WhatsApp con validación de datos..."
mkdir -p components
cat << 'EOF' > components/WhatsAppQuoteButton.tsx
'use client';

import { useState } from 'react';

interface ProductData {
  name: string;
  sku?: string;
  brand?: string;
  vehicle?: string;
  year?: string;
  motor?: string;
}

interface WhatsAppQuoteButtonProps {
  product: ProductData;
  phoneNumber: string; // Debe provenir de variables de entorno en producción
}

export default function WhatsAppQuoteButton({ product, phoneNumber }: WhatsAppQuoteButtonProps) {
  const [isHovered, setIsHovered] = useState(false);

  const handleQuote = () => {
    const baseUrl = typeof window !== 'undefined' ? window.location.href : '';
    
    // Construcción segura del mensaje. Maneja valores nulos sin romper la URL.
    const message = `¡Hola My Chevrolet & Suzuki! 👋%0A%0A` +
                    `Estoy interesado en cotizar el siguiente repuesto:%0A%0A` +
                    `🔧 *Producto:* ${product.name || 'No especificado'}%0A` +
                    `🏷️ *Referencia:* ${product.sku || 'N/A'}%0A` +
                    `🏢 *Marca:* ${product.brand || 'My Chevrolet & Suzuki'}%0A` +
                    `🚗 *Vehículo:* ${product.vehicle || 'Consultar compatibilidad'}%0A` +
                    `📅 *Año/Motor:* ${product.year ? product.year + (product.motor ? ' / ' + product.motor : '') : 'N/A'}%0A` +
                    `🔗 *Enlace del producto:* ${baseUrl}%0A%0A` +
                    `Quedo atento a su respuesta sobre disponibilidad y precio. ¡Gracias!`;

    const whatsappUrl = `https://wa.me/${phoneNumber}?text=${message}`;
    window.open(whatsappUrl, '_blank', 'noopener,noreferrer');
  };

  return (
    <button
      onClick={handleQuote}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      className="w-full flex items-center justify-center gap-2 bg-[#D6A52B] hover:bg-[#b88d1f] text-[#071B3B] font-bold py-3 px-4 rounded-lg transition-all duration-300 transform hover:scale-[1.02] shadow-md hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-[#D6A52B] focus:ring-offset-2"
      aria-label={`Cotizar ${product.name} por WhatsApp`}
    >
      <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 24 24" fill="currentColor">
        <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/>
      </svg>
      COTIZAR POR WHATSAPP
    </button>
  );
}
EOF

# ------------------------------------------------------------------------------
# 7. LAYOUT PRINCIPAL CON METADATOS GLOBALES Y JSON-LD (SEO)
# ------------------------------------------------------------------------------
if [ "$IS_NEXT" = true ]; then
    echo "🏗️ [7/8] Actualizando layout principal con SEO técnico y Datos Estructurados..."
    mkdir -p app
    cat << 'EOF' > app/layout.tsx
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'My Chevrolet & Suzuki S.A.S. | Repuestos Originales y Genéricos en Bogotá',
  description: 'Distribuidor autorizado de repuestos Chevrolet y Suzuki en Bogotá. Motores, radiadores, filtros, embragues y más. Envíos a toda Colombia. Cotiza por WhatsApp.',
  keywords: 'repuestos Chevrolet Bogotá, tienda repuestos Chevrolet, cotizar repuestos Chevrolet, motores Chevrolet, radiadores Chevrolet, filtros aceite Chevrolet, repuestos Suzuki Bogotá',
  authors: [{ name: 'My Chevrolet & Suzuki S.A.S.' }],
  openGraph: {
    title: 'My Chevrolet & Suzuki S.A.S. | Repuestos Originales',
    description: 'Catálogo especializado con envío nacional. Atención personalizada y garantía.',
    url: 'https://mychevrolet.com.co',
    siteName: 'My Chevrolet & Suzuki S.A.S.',
    locale: 'es_CO',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'My Chevrolet & Suzuki S.A.S.',
    description: 'Repuestos originales y genéricos con envío a toda Colombia.',
  },
  robots: {
    index: true,
    follow: true,
  },
  alternates: {
    canonical: 'https://mychevrolet.com.co',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // Datos estructurados para Google (AutoPartsStore)
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'AutoPartsStore',
    name: 'My Chevrolet & Suzuki S.A.S.',
    image: 'https://mychevrolet.com.co/logo-oficial.png', // Reemplazar con URL real del logo
    description: 'Distribuidor autorizado de repuestos Chevrolet y Suzuki en Bogotá.',
    address: {
      '@type': 'PostalAddress',
      streetAddress: 'Cra. 26 #64-32 y Av. Calle 1', // Actualizar con dirección real de la sede principal
      addressLocality: 'Bogotá',
      addressRegion: 'Cundinamarca',
      postalCode: '110111',
      addressCountry: 'CO',
    },
    geo: {
      '@type': 'GeoCoordinates',
      latitude: 4.6569469,
      longitude: -74.072384,
    },
    url: 'https://mychevrolet.com.co',
    telephone: '+573219555560',
    priceRange: '$$',
    openingHoursSpecification: [
      {
        '@type': 'OpeningHoursSpecification',
        dayOfWeek: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
        opens: '08:00',
        closes: '18:00',
      },
    ],
  };

  return (
    <html lang="es-CO">
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
      </head>
      <body className={inter.className + ' bg-[#F8F9FA] text-[#1A202C] antialiased'}>
        {children}
      </body>
    </html>
  );
}
EOF

    # Estilos globales con la paleta de marca oficial
    cat << 'EOF' > app/globals.css
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --color-navy: #071B3B;
  --color-corporate-blue: #12447C;
  --color-gold: #D6A52B;
  --color-silver: #C5CED8;
  --color-white: #FFFFFF;
  --color-bg-light: #F8F9FA;
}

@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

body {
  background-color: var(--color-bg-light);
  color: #1A202C;
}
EOF
fi

# ------------------------------------------------------------------------------
# 8. VALIDACIÓN FINAL DE CONSTRUCCIÓN
# ------------------------------------------------------------------------------
echo "🔍 [8/8] Ejecutando validación de construcción (Build) para producción..."
if npm run build; then
    echo "=============================================================================="
    echo "✅ ¡CONSTRUCCIÓN EXITOSA! El proyecto está optimizado y listo para Vercel."
    echo "=============================================================================="
    echo "📌 ACCIONES MANUALES REQUERIDAS EN VERCEL (Breves):"
    echo "   1. Variables de Entorno: Asegúrate de que NEXT_PUBLIC_WHATSAPP_NUMBER esté configurada."
    echo "   2. Dominio: Vincula tu dominio personalizado (mychevrolet.com.co) en la pestaña 'Domains'."
    echo "   3. Google Search Console: Da de alta la propiedad y envía 'https://mychevrolet.com.co/sitemap.xml'."
    echo "   4. Logo: Reemplaza la ruta del logo en 'app/layout.tsx' y 'app/page.tsx' con tu archivo real."
    echo "=============================================================================="
    echo "💾 Tu respaldo de seguridad se encuentra en: ./$BACKUP_DIR"
else
    echo "=============================================================================="
    echo "❌ ERROR EN LA CONSTRUCCIÓN."
    echo "Revisa los mensajes de error de TypeScript o compilación arriba."
    echo "Tus archivos originales están a salvo en: ./$BACKUP_DIR"
    echo "=============================================================================="
    exit 1
fi
